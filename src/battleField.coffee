class window.BattleField extends IsometricMap

  constructor: (opts, @state) ->
    super opts
    Common.battleField = this

    @selectedUnit = null
    @curTile = null

    #TODO: put those variables somewhere else
    @loadout
    @target
  init: () ->
    @tileBoundingPoly.color = 'rgba(50,20,240,0.4)'

    # Polygon for move and attack range
    @attRangePoly = {}
    $.extend @attRangePoly, @tileBoundingPoly
    @attRangePoly.color = 'rgba(240,20,50,0.4)'

    @moveRangePoly = {}
    $.extend @moveRangePoly, @tileBoundingPoly

    @initSounds()
    super()
    
    #TODO: hardcoded two units 
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]


    unit = new Unit charSpriteSheet, {
      name: "Black Commander 1"
      hp: 100
      moveRange: 5
      evasion: 0.1
      skill: 50
    }, @tiles[10][10], 'img/head.png'

    @addObject(unit, 10, 10)
    @tiles[10][10].occupiedBy = unit
    
    
    
    
    # Weapon @name, @cost, @range, @power, @parry, @passiveAbilitiesList, @iconFile
    
    #Create new Armor/Weapon and equip
    armor = new Armor "Knight Plate Armor",{
      cost: 2
      defense: 2
    }, null
    
    armor2 = new Armor "Knight Plate Armor", {
      cost: 2
      defense: 2
    }, null, 'img/item2.png'
    
    
    weapon = new Weapon "Poison­Tipped Sword", {
      cost: 2
      range: 2
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'

    weapon1 = new Weapon "Long Sword", {
      cost: 2
      range: 2
      power: 1
      parry: 0.2
    }, null, 'img/item3.png'
    

    #for i in [0...3]
    unit.equip(armor)
    unit.equip(armor2)
    #unit.equip(armor3)
    unit.equip(armor)
    unit.equip(weapon)
    unit.equip(weapon1)

    unit2 = new Unit charSpriteSheet, {
      name: "Black Commander 2"
      hp: 100
      moveRange: 10
      evasion: 0.5
      skill: 30
    }, @tiles[11][10], null

    for i in [0...40]
      unit2.equip(armor2)

    @addObject(unit2, 11, 10)
    @tiles[11][10].occupiedBy = unit2

    # Register input event listeners
    @addListener 'mouseMove', @onMouseMove.bind this
  
    # listeners to move the map
    window.addEventListener "keydown", ((e) ->
      if e.keyCode in [37, 38, 39, 40]
        e.preventDefault()
    ),false

    @onKeyDown 37, ( ->
      @position.x += 15
    ).bind this
    @onKeyDown 38, ( ->
      @position.y += 15
    ).bind this
    @onKeyDown 39, ( ->
      @position.x -= 15
    ).bind this
    @onKeyDown 40, ( ->
      @position.y -= 15
    ).bind this


    # Register game event listeners
    @addListener 'unitSelected', @onUnitSelected.bind this
    @addListener 'unitMove', @onUnitMove.bind this
    @addListener 'loadoutSelectTarget', @onLoadoutSelectTarget.bind this
    @addListener 'applyLoadout', @onApplyLoadout.bind this
    @addListener 'selectAttackTarget', @onSelectAttackTarget.bind this
    @addListener 'unitAttack', @onUnitAttack.bind this
      


#---------------------------------------------------------------------------------------------------
# Event listeners
#---------------------------------------------------------------------------------------------------
  onMouseMove: (evt) ->
    for i in [0...@tiles.length-1]
      row = @tiles[i]
      for j in [0...row.length-1]
        tile = row[j]
        x = i*-@tileXOffset + j*@tileXOffset + @mapOffset
        y = i*@tileYOffset + j*@tileYOffset
        if tile.containsPoint evt.x-x+1, evt.y-y+1
          tile.showPoly()
        else
          tile.hidePoly()


  onUnitSelected: (evt) ->
    @selectedUnit = evt.target
    if @selectedUnit.moveTokens <= 0
      Common.game.battleLog 'Cannot move anymore in this turn'
      return
    @curTile = evt.origin
    @state.mode = 'move'
    @highlightRange @selectedUnit, @selectedUnit.stats.moveRange, @moveRangePoly
      
  onUnitMove: (evt) ->
    @resetHighlight()
    u = @selectedUnit
    tile = @tiles[@curTile.row][evt.col]
    finalTile = @tiles[evt.row][evt.col]
    #@runSound.play() # Play move sound
    if not (@inRange u.onTile, finalTile, u.stats.moveRange) or (finalTile.occupiedBy != null)
       @state.mode = 'select'
       return
    targetTile = @tiles[evt.row][evt.col]
    @tiles[@curTile.row][@curTile.col].occupiedBy = null
    console.log 'Moving from ', @curTile, 'To', targetTile
    pathQ = @findPath @curTile, targetTile
    if pathQ?    
      @state.mode = 'unitMoving'
      @curTile.occupiedBy = null 
      @moveUnit pathQ, @selectedUnit, finalTile
    else
      Common.game.battleLog 'Cant move to that tile'
      @tiles[@curTile.row][@curTile.col].occupiedBy = @selectedUnit
      @state.mode = 'select'  
    
   
  onLoadoutSelectTarget: (evt) ->
    @state.mode = 'select'
    @state.type = 'loadout'
    @loadout = evt.item
    console.log 'Loadout Item', evt.item


  onApplyLoadout: (evt) ->
    console.log 'loadout to', evt.target, 'item: ', @loadout
    Common.loadout.remove @loadout
    Common.cPanel.updatePanel() # update the panel
    # Applying an item of Weapon/Armor to a unit
    if (evt.target instanceof Unit and (@loadout instanceof Armor or @loadout instanceof Weapon))
      evt.target.equip @loadout
      #TODO: Select the unit after equipping
    else if (evt.target instanceof BFTile and @loadout instanceof Unit)
      col = evt.target.col
      row = evt.target.row
      @addObject(@loadout,row, col)
      @tiles[row][col].occupiedBy = @loadout
      @loadout.onTile = evt.target
     # Update cPanel if target unit is selected
     if evt.target is Common.selected
       @updateCP() 
    else
      Common.game.battleLog 'Invalid target to apply loadout item'
    
    # Reset state
    @state.mode = 'select'
    @state.type = 'normal'
    
  onSelectAttackTarget: (evt) ->
    Common.game.changeCursor 'cursor/attack.cur'
    @resetHighlight()
    if @selectedUnit.actionTokens <= 0
      Common.game.battleLog 'Cannot perform more attacks this turn'
      @state.mode = 'select'
      return
    console.log 'select Attack Target'
    # Show attack range
    @state.mode = 'attack'
    if @selectedUnit.weaponActive
      @highlightRange @selectedUnit, @selectedUnit.getWeaponRange(), @attRangePoly
    else
      alert "Unit does not have weapon to attack"
      @state.mode = 'select'

  onUnitAttack: (evt) ->
    @resetHighlight()
    # Check Range
    if evt.target instanceof Unit
      if (@inRange @selectedUnit.onTile, evt.target.onTile, @selectedUnit.getWeaponRange()) and (@selectedUnit.onTile != evt.target.onTile) # TODO: add logic to make sure a unit can not attack an ally
        # Perform attack
        @selectedUnit.attack evt.target
        @selectedUnit.actionTokens -= 1
        @state.mode = 'select'
        if evt.target.curhp <= 0
            @removeUnit evt.target
        #need to reset the shading
    else
      #TODO: Add logic to attack tiles
      #need to reset the shading
    @state.mode = 'select'
    Common.game.changeCursor 'cursor/heros.cur'


#---------------------------------------------------------------------------------------------------
# Member functions
#---------------------------------------------------------------------------------------------------

  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (startTile, endTile) ->
    # initialize map 
    @m = []
    # build map from map tiles
    for i in [0...@tiles.length]
      row = @tiles[i]
      @m[i] = []
      for j in [0...row.length]  
        @m[i][j] = "-"      
    @m[endTile.row][endTile.col] = 'E'
 
    @genMap @m, @curTile, @tiles[endTile.row][endTile.col]
    return @genPath @m, @curTile
     
  genMap: (map, startTile, endTile)->
    pathQ = [{row: endTile.row, col: endTile.col, counter: 0}]
    index = 0
    current = pathQ[0]

    while current?
      #console.log 'loop', @tiles
      r = current.row
      c = current.col
      coun = current.counter + @tiles[r][c].move
      #console.log 'current', current
      if r is startTile.row and c is startTile.col
        console.log 'reached'
        break
      newList = [{row: r, col:c-1, counter: coun}
                  {row: r+1, col:c, counter: coun}
                  {row: r-1, col:c, counter: coun}
                  {row: r, col:c+1, counter: coun}]
      for ele in newList
        better = false        
        for e in pathQ
          if e.col == ele.col and e.row == ele.row
            if e.counter < ele.counter 
              better = true
            else 
              re = e
        pathQ.remove re      
        #console.log 'row---col', ele.row ,'---', ele.col, @tiles
        if better == true
          #console.log 'Better Way'
        else if ele.col < 0 or ele.col >= 30
          #console.log 'hit wall'
        else if ele.row < 0 or ele.row >= 30
          #console.log 'hit wall'  
        else if @tiles[ele.row][ele.col].occupiedBy?
          #console.log 'hit wall'  
        else
          #console.log 'push', ele 
          pathQ.push ele
      index += 1
      current = pathQ[index]
      
    console.log 'QUEUE' , pathQ   
    @printPath @m
    for elem in pathQ
      console.log 'modify'
      @m[elem.row][elem.col] = elem.counter
    @printPath @m

  # generate path that the unit need to travel to get to dest
  # [{col,row},{col,row}..]
  genPath: (m, startTile) ->
    current = {row: startTile.row, col: startTile.col}
    queue = [current]
    steps = m[current.row][current.col]
    console.log m
    while steps != 0
      console.log 'Step', steps
      
      possibleSteps = [{row:current.row+1, col:current.col}
                       {row:current.row-1, col:current.col}
                       {row:current.row, col:current.col+1}
                       {row:current.row, col:current.col-1}]                
      best = 9999
      row = 0
      col = 0
      
      if m[current.row][current.col] is '-' 
        console.log 'cant reach'
        return

      for s in possibleSteps
        counter = m[s.row][s.col]
        console.log 'Coutner', counter
        if (counter < best)
          row = s.row
          col = s.col
          best = counter
      steps = best        
      queue.push {row:row, col:col}     
      current = {row:row, col:col}
       
    console.log 'Path queue', queue
    return queue
         
  printPath: (m) ->
    s = ""
    for i in [0...m.length]
      if i < 10
        s = s + "   " + i
      else
        s = s + "  " + i
    console.log s
    for i in [0...m.length]
      s = ""
      row = m[i]
      for j in [0...row.length]
        s = s + "   " + m[i][j]
      s += i
      console.log  s

  # Move unit throught a path queue
  moveUnit: (pathQ, unit, finalTile) ->
    if pathQ.length is 0
      @state.mode = 'select'
      unit.sprite.play 'idle'
      finalTile.occupiedBy = unit
      unit.onTile = finalTile
      @curTile = finalTile
      return
    else
      current = pathQ[0]
      tween = unit.moveTo @tiles[current.row][current.col]
      unit.onTile = @tiles[current.row][current.col]
      tween.onComplete ( ->
        pathQ.remove pathQ[0]
        @moveUnit pathQ , unit, finalTile
      ).bind this

  # Highlight range on isometric map  
  highlightRange: (unit, range, poly) ->
    console.log 'cuurent at', unit.onTile
    # Reset graph before highlighting
    @resetHighlight()
    for i in [0...@tiles.length]
      row = @tiles[i]
      for j in [0...row.length]
        tile = row[j]
        if @inRange(unit.onTile, tile, range)
          tile.addChild poly
             
  # Check if target position is in range of current position
  inRange: (curPos, tarPos, range) ->
    diffCol = Math.abs(tarPos.col - curPos.col)
    diffRow = Math.abs(tarPos.row - curPos.row)
    return (diffCol + diffRow) <= range
    
  # Remove an unit form the battle field  
  removeUnit: (unit) ->
    for i in [0...30]
      for j in [0...30]
        if @tiles[i][j].occupiedBy is unit
          @tiles[i][j].occupiedBy = null
    @removeChild(unit)
   
  # Reset tiles 
  resetHighlight: () ->
    for i in [0..29]
      for j in [0..29]
        @tiles[i][j].removeChild @attRangePoly
        @tiles[i][j].removeChild @moveRangePoly
        #TODO: remove character selection from the control panel. The easiest way to do this is to move the instance of cPanel in game.coffee into this file  
  # Initialize sound effects for battle fields here
  initSounds: () ->
    
    # Run sound for unit
    @runSound = new Audio "audio/toon.wav"
    @runSound.addEventListener 'ended', ((evt)->
      console.log 'sound finished'
      @runSound.currentTime = 0
      @runSound.play();  
    ).bind this
#---------------------------------------------------------------------------------------------------
# Overridden functions
#---------------------------------------------------------------------------------------------------
  # Override for performance. Only sift down click events
  handle: (evt) ->
    if Event.isMouseEvent evt
      if not @containsPoint evt.x, evt.y
        return false
      evt.target = this

    if evt.type == 'click'
      if @children.length >= 0
        for i in [@children.length-1..0] by -1
          child = @children[i]
          # transform event coordinates
          evt.x = evt.x - child.position.x
          evt.y = evt.y - child.position.y
          isHandled = child.handle evt
          # untransform event coordinates
          evt.x = evt.x + child.position.x
          evt.y = evt.y + child.position.y
          if Event.isMouseEvent evt and isHandled
            return true

    isHandled = false
    for listener in @listeners
      if evt.type == listener.type
        isHandled = true
        listener.handler evt
    return isHandled

  # Update cp
  updateCP: () ->
    Common.cPanel.updatePanel()
