class window.BattleField extends IsometricMap

  constructor: (opts, @state, @player, @enemy) ->
    super opts
    Common.battleField = this

    @selectedUnit = null
    @curTile = null

    @highlightLayer = []

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

    #Change mode to select
    @state.changeToMode 'select'

    # @initSounds() 
    super()
  
    @addUnits @player
    @addUnits @enemy

    #Common.cPanel.initLoadOut()
    
    
    # Register input event listeners
    @addListener 'mouseMove', @onMouseMove.bind this
    @addListener 'keyPress', @onKeyPress.bind this

    # listeners to move the map/ reset focus
    window.addEventListener "keydown", ((e) ->
      if e.keyCode in [37, 38, 39, 40, 27]
        e.preventDefault()
    ),false

    @onKeyDown 37, ( ->
      #if @position.x < 0
      @position.x += 15
    ).bind this
    
    @onKeyDown 38, ( ->
      # Hard coded value to tall building
      #if @position.y < 500
      @position.y += 15
    ).bind this
    
    @onKeyDown 39, ( ->
      #if (Math.abs @position.x ) < 1280
      @position.x -= 15
    ).bind this
    
    @onKeyDown 40, ( ->
      #if (Math.abs @position.y ) < 525
      @position.y -= 15
    ).bind this
  
    @onKeyDown 27, ( ->
      @resetHighlight()
      @state.changeToMode 'select'
      @state.type = 'normal'
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

  onKeyPress: (evt) ->
    ##console.log 'key', evt.which
    if evt.which == 13
      if Common.state.turn != @enemy
        @resetHighlight()
        @state.endTurn()

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
    ##console.log 'unit selected', @selectedUnit.belongsTo
    if @selectedUnit.belongsTo != @state.turn
      Common.game.battleLog 'Cannot control this unit'
      return
    if @selectedUnit.moveTokens <= 0
      Common.game.battleLog 'Cannot move anymore in this turn'
      return
    @curTile = evt.origin
    @state.changeToMode 'move'
    @highlightMoveRange @selectedUnit, @selectedUnit.stats.moveRange, @moveRangePoly
      
  onUnitMove: (evt) ->
    @resetHighlight()
    ##console.log 'move to', evt
    @moveUnit @selectedUnit, evt.row, evt.col

  onLoadoutSelectTarget: (evt) ->
    @state.changeToMode 'select'
    @state.type = 'loadout'
    @loadout = evt.item
    ##console.log 'Loadout Item', evt.item

  onApplyLoadout: (evt) ->
    ##console.log 'loadout to', evt.target, 'item: ', @loadout
    # Applying an item of Weapon/Armor to a unit
    ##console.log "@loadot.cost", @loadout
    if @loadout.stats.cost <= @getPlayerIP(@player)
      Common.game.battleLog 'Please select loadout item target'
      if (evt.target instanceof Unit and (@loadout instanceof Armor or @loadout instanceof Weapon))
        if evt.target.belongsTo == @enemy
          Common.game.battleLog 'Cannot equip item to enemy unit'
        else
          evt.target.equip @loadout
          Common.loadout.remove @loadout
          @setPlayerIP @player, (@getPlayerIP(@player) - @loadout.stats.cost)

          #console.log 'Loadout: ', Common.loadout
          #TODO: Select the unit after equipping
      else if (evt.target instanceof BFTile and @loadout instanceof Unit)
        
        col = evt.target.col
        row = evt.target.row
        # TODO: this is kind of hacky, should at least differenciate type of units later
        # basically the old unit is not loaded properly because it's not added to the scene
        # so we create a new unit from the loadout unit to add
        if (@loadout instanceof Soldier)
          unitToAdd = new Soldier row, col
        else if (@loadout instanceof Archer)
          unitToAdd = new Archer row, col
        else
          unitToAdd = new Soldier row, col
          
        
        Common.player.addUnit unitToAdd
        ##console.log 'add UNIT234', unitToAdd
        @addObject(unitToAdd,row, col)
        #console.log 'row col', row, col, unitToAdd 
        @tiles[row][col].occupiedBy = unitToAdd
        unitToAdd.onTile = evt.target
        Common.loadout.remove @loadout
        @setPlayerIP @player, (@getPlayerIP(@player) - @loadout.stats.cost)

      else
        Common.game.battleLog 'Invalid target to apply loadout item'
     

    else
      Common.game.battleLog 'Not enough Initiative Points'
   
    Common.cPanel.updatePanel() # update the panel
    # Reset state
    @state.changeToMode 'select'
    @state.type = 'normal'
    
  onSelectAttackTarget: (evt) ->
    Common.game.changeCursor 'cursor/attack.cur'
    @resetHighlight()
    if @selectedUnit.belongsTo != @state.turn
      Common.game.battleLog 'Cannot control this unit'
      return
    if @selectedUnit.actionTokens <= 0
      Common.game.battleLog 'Cannot perform more attacks this turn'
      @state.changeToMode 'select'
      return
    if not @selectedUnit.weaponActive
      Common.game.battleLog 'Unit does not have weapon to attack'
      @state.changeToMode 'select'
      return

    # Show attack range
    @state.changeToMode 'attack'
    if @selectedUnit.weaponActive
      @highlightAttackRange @selectedUnit, @selectedUnit.getWeaponRange(), @attRangePoly
    else
      alert "Unit does not have weapon to attack"
      @state.changeToMode 'select'

  onUnitAttack: (evt) ->
    if evt.target.belongsTo == @state.turn
      Common.game.battleLog 'Cannot attack own unit'
      return

    @resetHighlight()
    # Check Range
    if evt.target instanceof Unit
      if (@inAttackRange @selectedUnit.onTile, evt.target.onTile, @selectedUnit.getWeaponRange()) and (@selectedUnit.onTile != evt.target.onTile) # TODO: add logic to make sure a unit can not attack an ally
        # Perform attack
        @unitAttack @selectedUnit, evt.target
        #need to reset the shading
    else
      #TODO: Add logic to attack tiles
      #need to reset the shading
    @state.changeToMode 'select'


#---------------------------------------------------------------------------------------------------
# Member functions
#---------------------------------------------------------------------------------------------------
  
  addUnits: (player) ->
    for u in player.units
      @addObject(u, u.row, u.col)
      u.onTile = @tiles[u.row][u.col]


  moveUnit: (u, row, col) ->
    #@runSound.play() # Play move sound
    fromTile = u.onTile
    targetTile = @tiles[row][col]

    if not (@inMoveRange fromTile, targetTile, u.stats.moveRange) or (targetTile.occupiedBy != null)
      console.log 'Reset Selection'
      @state.changeToMode 'select'
      @selectedUnit = null 
      Common.selected = null
      Common.cPanel.updatePanel()
      return

    if not targetTile.occupiedBy?
       
      fromTile.occupiedBy = null
      #console.log 'Moving from ', fromTile, 'To', targetTile
      pathQ = @findPath fromTile, targetTile
      if pathQ?
        @state.changeToMode 'unitMoving'
        fromTile.occupiedBy = null 
        @moveUnitPath pathQ, u, targetTile
        u.moveTokens -=1
      else
        Common.game.battleLog 'Cant move to that tile'
        fromTile.occupiedBy = u
          

  unitAttack: (attacker, target) ->
    attacker.attack target
    attacker.actionTokens -= 1

  # Finds an empty tile in range of unit to move to, starting with
  # the supplied tile and going outwards
  findEmptyTile: (tile, unit) ->
    q = []
    q.push tile
    
    @resetMapArray()
    @genMap @m, null , unit.onTile
    
    
    for row in @tiles
      for t in row
        t.seen = false

    while q.length > 0
      t = q.shift()
      if t.seen == true
        continue

      r = t.row
      c = t.col
      if (t.occupiedBy == null) and (@m[t.row][t.col] < unit.stats.moveRange)
        return t
      t.seen = true

      if r+1 < Common.mapSize.row
        q.push @tiles[r+1][c]
      if c+1 < Common.mapSize.col
        q.push @tiles[r][c+1]
      if r-1 >= 0
        q.push @tiles[r-1][c]
      if c-1 >= 0
        q.push @tiles[r][c-1]



  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (startTile, endTile) ->  
    @resetMapArray()
    @genMap @m, startTile, @tiles[endTile.row][endTile.col]
    return @genPath @m, @tiles[startTile.row][startTile.col]
     
  genMap: (map, startTile, endTile)->
    pathQ = [{row: endTile.row, col: endTile.col, counter: 0}]
    index = 0
    current = pathQ[0]

    while current?
      #console.log 'loop', @tiles
      r = current.row
      c = current.col
      coun = current.counter + @tiles[r][c].tileMoveCost
      #console.log 'move Cost', @tiles[r][c].tileMoveCost
      #console.log 'current', current
      if startTile?
        if r is startTile.row and c is startTile.col
          #console.log 'reached'
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
        else if ele.col < 0 or ele.col >= Common.mapSize.col
          #console.log 'hit wall'
        else if ele.row < 0 or ele.row >= Common.mapSize.row
          #console.log 'hit wall'  
        else if @tiles[ele.row][ele.col].occupiedBy?
          #console.log 'hit wall'  
        else
          #console.log 'push', ele 
          pathQ.push ele
      index += 1
      current = pathQ[index]
      
    console.log 'QUEUE' , pathQ   
    for elem in pathQ
      ##console.log 'modify'
      map[elem.row][elem.col] = elem.counter
   #@printPath map

  # generate path that the unit need to travel to get to dest
  # [{col,row},{col,row}..]
  genPath: (m, startTile) ->
    current = {row: startTile.row, col: startTile.col}
    queue = [current]
    steps = m[current.row][current.col]
    #console.log m
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
      console.log s

  # Move unit throught a path queue
  moveUnitPath: (pathQ, unit, finalTile) ->
    if pathQ.length is 0
      @state.changeToMode 'select'
      #unit.sprite.play 'idle'
      unit.sprite.stop()
      finalTile.occupiedBy = unit
      unit.onTile = finalTile
      #@curTile = finalTile
      return
    else
      current = pathQ[0]
      unit.onTile.occupiedBy = null
      tween = unit.moveTo @tiles[current.row][current.col]
      unit.onTile = @tiles[current.row][current.col]
      tween.onComplete ( ->
        pathQ.remove pathQ[0]
        @moveUnitPath pathQ , unit, finalTile
      ).bind this

  # Highlight range on isometric map  
  highlightMoveRange: (unit, range, poly) ->
    # initialize map 
    @resetMapArray()
    s = (new Date()).getTime()
    @genMap @m, null , unit.onTile
    e = (new Date()).getTime()
    console.log 'genmap run time', s, e, e-s
    # Reset graph before highlighting
    @resetHighlight()
    for i in [0...@tiles.length]
      row = @tiles[i]
      for j in [0...row.length]
        tile = row[j]
        if (@m[i][j] <= range) && tile.walkable
          #(@inRange unit.onTile, tile, range) and (tile.occupiedBy == null)
          p = {}
          $.extend true, p, poly
          p.setPosition tile.position.x, tile.position.y
          @highlightLayer.push p
          console.log 'tile pos pos 0', @highlightLayer[0].position

    for t in @highlightLayer
      console.log 'highlightLayer', t.position
  
             
  # Check if target position is in range of current position
  inMoveRange: (curPos,tarPos, range) ->
    @resetMapArray()
    @genMap @m, null , curPos
    #console.log 'Range:' ,@m[tarPos.row][tarPos.col]
    return (@m[tarPos.row][tarPos.col] <= range) && tarPos.walkable
    
  highlightAttackRange: (unit, range, poly)->
        # Reset graph before highlighting
    @resetHighlight()
    for i in [0...@tiles.length]
      row = @tiles[i]
      for j in [0...row.length]
        tile = row[j]
        if (@inAttackRange unit.onTile, tile, range) 
          #(@inRange unit.onTile, tile, range) and (tile.occupiedBy == null)
          p = {}
          $.extend true, p, poly
          @highlightLayer.push p
          p.setPosition tile.position.x, tile.position.y
    
  inAttackRange: (curPos, tarPos, range) ->
    diffCol = Math.abs(tarPos.col - curPos.col)
    diffRow = Math.abs(tarPos.row - curPos.row)
    return (diffCol + diffRow) <= range    
  
  # Returns map array
  resetMapArray: -> 
    # initialize map 
    @m = []
    # build map from map tiles
    for i in [0...@tiles.length]
      row = @tiles[i]
      @m[i] = []
      for j in [0...row.length]  
        @m[i][j] = "-" 
    
  # Remove an unit form the battle field  
  removeUnit: (unit) ->
    unit.onTile.occupiedBy = null
    @objLayer.remove unit
    @player.removeUnit unit
    @enemy.removeUnit unit
   
  # Reset tiles 
  resetHighlight: () ->
    @highlightLayer = []
    #for i in [0...Common.mapSize.row]
      #for j in [0...Common.mapSize.col]
        #@tiles[i][j].removeChild @attRangePoly
        #@tiles[i][j].removeChild @moveRangePoly
        #TODO: remove character selection from the control panel. The easiest way to do this is to move the instance of cPanel in game.coffee into this file  
  

  getPlayerIP: (player) ->
    return player.initiativePoints
  
  setPlayerIP: (player, ip) ->
      player.initiativePoints = ip
      evt =
        type: 'ipValueChange'
      @dispatchEvent evt
      console.log 'set IP', ip
      
  # Update cp
  updateCP: () ->
    Common.cPanel.updatePanel()


  addObjectHelper: (obj, i, j, listener=null) ->
    ##console.log 'addObjectHelper', listener
    if listener
      @removeListener listener

    x = i*-@tileXOffset + j*@tileXOffset + @mapOffset
    y = i*@tileYOffset + j*@tileYOffset
    ##console.log 'obj.size.h', obj.size.h
    y -= obj.size.h
    y += @tileHeight
    for i in [0...obj.width-1]
      y += (@tileYOffset*2)
      x -= @tileXOffset
    obj.setPosition x, y

    obj.anchorY = obj.size.h
    for i in [0...obj.width]
      obj.anchorY -= @tileYOffset
    ##console.log 'anchor', obj.anchorY


#---------------------------------------------------------------------------------------------------
# Overridden functions
#---------------------------------------------------------------------------------------------------
  # Override for performance.
  handle: (evt) ->
    if Event.isMouseEvent evt
      if not @containsPoint evt.x, evt.y
        return false
      evt.target = this

    if evt.type in ['click']
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

    if evt.type in ['click', 'spriteImageLoaded', 'resize', 'spriteStopAnim']
      if @objLayer.length >= 0
        for i in [@objLayer.length-1..0] by -1
          child = @objLayer[i]
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


  addObject: (obj, i, j) ->
    ##console.log @children.length, @objLayer.length
    @objLayer.push obj
    for ii in [0...obj.width]
      for jj in [0...obj.height]
        @tiles[i+ii][j+jj].occupiedBy = obj

    if obj.loaded
      addObjectHelper obj, i, j
      return

    #console.log 'addObject dispatch event'
    listener = @addListener 'bfObjectReady', ((evt) ->
      console.log 'bfObjectReady'
      if obj == evt.target
        @addObjectHelper evt.target, i, j, listener
    ).bind this


  draw: (ctx) ->
    ctx.save()
    ctx.translate @position.x, @position.y
    for child in @children
      if child.visible then child.draw ctx

    for tile in @highlightLayer
      if tile.visible then tile.draw ctx

    @objLayer.sort ((a, b) ->
      (a.position.y + a.anchorY) - (b.position.y + b.anchorY)
    )
    #console.log @objLayer
    for obj in @objLayer
      if obj.visible then obj.draw ctx


    ctx.restore()
