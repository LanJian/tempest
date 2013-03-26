class window.BattleField extends IsometricMap

  constructor: (opts, @state, @player, @enemy) ->
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

    @addUnits @player
    @addUnits @enemy


    # Register input event listeners
    @addListener 'mouseMove', @onMouseMove.bind this
    @addListener 'keyPress', @onKeyPress.bind this

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

  onKeyPress: (evt) ->
    if evt.which == 13
      console.log 'end turn'
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
    if @selectedUnit.belongsTo != @state.turn
      Common.game.battleLog 'Cannot control this unit'
      return
    if @selectedUnit.moveTokens <= 0
      Common.game.battleLog 'Cannot move anymore in this turn'
      return
    @curTile = evt.origin
    @state.mode = 'move'
    @highlightRange @selectedUnit, @selectedUnit.stats.moveRange, @moveRangePoly
      
  onUnitMove: (evt) ->
    @resetHighlight()
    @moveUnit @selectedUnit, evt.row, evt.col
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
    @resetHighlight()
    if @selectedUnit.belongsTo != @state.turn
      Common.game.battleLog 'Cannot control this unit'
      return
    if @selectedUnit.actionTokens <= 0
      Common.game.battleLog 'Cannot perform more attacks this turn'
      @state.mode = 'select'
      return
    if not @selectedUnit.weaponActive
      Common.game.battleLog 'Unit does not have weapon to attack'
      @state.mode = 'select'
      return

    console.log 'select Attack Target'
    # Show attack range
    @state.mode = 'attack'
    @highlightRange @selectedUnit, @selectedUnit.weaponActive.range, @attRangePoly

  onUnitAttack: (evt) ->
    if evt.target.belongsTo == @state.turn
      Common.game.battleLog 'Cannot attack own unit'
      return

    @resetHighlight()
    # Check Range
    if evt.target instanceof Unit
      if (@inRange @selectedUnit.onTile, evt.target.onTile, @selectedUnit.weaponActive.range) and (@selectedUnit.onTile != evt.target.onTile) # TODO: add logic to make sure a unit can not attack an ally
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

#---------------------------------------------------------------------------------------------------
# Member functions
#---------------------------------------------------------------------------------------------------
  
  addUnits: (player) ->
    for u in player.units
      @addObject(u, u.row, u.col)
      @tiles[u.row][u.col].occupiedBy = u
      u.onTile = @tiles[u.row][u.col]


  moveUnit: (u, row, col) ->
    fromTile = u.onTile
    tile = @tiles[fromTile.row][col]
    finalTile = @tiles[row][col]
    #@runSound.play() # Play move sound
    if not (@inRange u.onTile, finalTile, u.stats.moveRange) or (finalTile.occupiedBy != null)
       @state.mode = 'select'
       return

    tween = u.moveTo tile
    @resetHighlight()
    @state.mode = 'unitMoving'

    fromTile.occupiedBy = null
    u.moveTokens -= 1

    tween.onComplete ( ->
     u.onTile = tile
     t = u.moveTo finalTile
     t.onComplete ( ->
       @state.mode = 'select'
       u.sprite.play 'idle'
       u.onTile = finalTile
       #@curTile = finalTile
       finalTile.occupiedBy = u
       @runSound.pause() # Stop move sound
     ).bind this
    ).bind this


  # Finds an empty tile in range of unit to move to, starting with
  # the supplied tile and going outwards
  findEmptyTile: (tile, unit) ->
    q = []
    q.push tile
    for row in @tiles
      for t in row
        t.seen = false

    while q.length > 0
      t = q.shift()
      if t.seen == true
        continue

      r = t.row
      c = t.col
      if (t.occupiedBy == null) and (@inRange t, unit.onTile, unit.stats.moveRange)
        return t
      t.seen = true

      if r+1 < 30
        q.push @tiles[r+1][c]
      if c+1 < 30
        q.push @tiles[r][c+1]
      if r-1 >= 0
        q.push @tiles[r-1][c]
      if c-1 >= 0
        q.push @tiles[r][c-1]



  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (size, start, end) ->
    
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
    @player.removeUnit unit
    @enemy.removeUnit unit
   
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
