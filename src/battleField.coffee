class window.BattleField extends IsometricMap
  constructor: (opts, @state) ->
    super opts

    @selectedUnit = null
    @curTile = null

  init: () ->
    @tileBoundingPoly.color = 'rgba(50,20,240,0.4)'

    # Polygon for move and attack range
    @attRangePoly = {}
    $.extend @attRangePoly, @tileBoundingPoly
    @attRangePoly.color = 'rgba(240,20,50,0.4)'

    @moveRangePoly = {}
    $.extend @moveRangePoly, @tileBoundingPoly

    super()
    
    
    
    #TODO: hardcoded two units 
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]
    
    charSpriteSheet1 = new SpriteSheet 'img/spriteSheet1.png', [
      {length: 3, cellWidth: 50, cellHeight: 70}
      {length: 3, cellWidth: 50, cellHeight: 70}
    ]


    unit = new Unit charSpriteSheet, {
      name: "Black Commander 1"
      hp: 100
      moveRange: 5
      evasion: 0.1
      skill: 50
    }, {col:10, row:10}, 'img/head.png'

    @addObject(unit, 10, 10)
    @tiles[10][10].occupiedBy = unit
    
    
    #Create new Armor/Weapon and equip
    armor = new Armor "Knight Plate Armor", 2, 1, null, 'img/item1.png'
    armor2 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item2.png'
    armor3 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item3.png'
    weapon = new Weapon "Poison­Tipped Sword", 2, 2, 1, 0.2, null, 'img/item2.png'

    #for i in [0..2]
    unit.equip(armor)
    unit.equip(armor2)
    unit.equip(armor3)
    unit.equip(armor)
    unit.equip(weapon)

    unit2 = new Unit charSpriteSheet, {
      name: "Black Commander 2"
      hp: 100
      moveRange: 5
      evasion: 0.1
      skill: 30
    }, {col:11, row:10}, null

    for i in [0..2]
      unit2.equip(armor3)


    @addObject(unit2, 11, 10)
    @tiles[11][10].occupiedBy = unit2

    @addListener 'unitSelected', ((evt) ->
      @selectedUnit = evt.target
      @curTile = evt.origin
      @state.mode = 'move'
      @highlightRange @selectedUnit, @selectedUnit.stats.moveRange, @moveRangePoly
    ).bind this

    @addListener 'unitMove', ((evt) ->
      u = @selectedUnit
      tile = @tiles[@curTile.row][evt.col]
      finalTile = @tiles[evt.row][evt.col]

      if not @inRange u.onTile, finalTile, u.stats.moveRange
         @state.mode = 'select'
         @reset()
         return

      tween = u.moveTo tile
      @state.mode = 'unitMoving'

      @curTile.occupiedBy = null
      @reset()

      tween.onComplete ( ->
       u.onTile = {col: tile.col, row: tile.row}
       t = u.moveTo finalTile
       t.onComplete ( ->
         @state.mode = 'select'
         u.sprite.play 'idle'
         u.onTile = {col: finalTile.col, row: finalTile.row}
         @curTile = finalTile
         finalTile.occupiedBy = u
       ).bind this
      ).bind this
    ).bind this
    
    # Listener for units attack
    @addListener 'selectAttackTarget', ((evt) ->
      @reset()
      console.log 'select Attack Target'
      # Show attack range
      @state.mode = 'attack'
      if @selectedUnit.weapon
        @highlightRange @selectedUnit, @selectedUnit.weapon.range, @attRangePoly
      else
        console.log 'Unit does not have weapon to attack'
    ).bind this
    
    @addListener 'unitAttack', ((evt) ->
      # Check Range
      if evt.target instanceof Unit
        if (@inRange @selectedUnit.onTile, evt.target.onTile, @selectedUnit.weapon.range) and  (@selectedUnit.onTile != evt.target.onTile) # TODO: add logic to make sure a unit can not attack an ally
          # Perform attack
          @selectedUnit.attack evt.target
          if evt.target.curhp <= 0
              @removeUnit evt.target
          @state.mode = 'select'
          #need to reset the shading
          @reset()
      else
        #TODO: Add logic to attack tiles
        @state.mode = 'select'
        #need to reset the shading
        @reset()
    ).bind this


    @addListener 'mouseMove', ((evt) ->
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
    ).bind this

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
    
   
  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (size, start, end) ->
    
  # Highlight range on isometric map  
  highlightRange: (unit, range, poly) ->
    console.log 'cuurent at', unit.onTile

    for i in [0...@tiles.length-1]
      row = @tiles[i]
      for j in [0...row.length-1]
        tile = row[j]
        if @inRange(unit.onTile, {col:j, row:i}, range)
          tile.addChild poly
             
  # Check if target position is in range of current position
  inRange: (curPos, tarPos, range) ->
    diffCol = Math.abs(tarPos.col - curPos.col)
    diffRow = Math.abs(tarPos.row - curPos.row)
    return (diffCol + diffRow) <= range
    
  # Remove an unit form the battle field  
  removeUnit: (unit) ->
    for i in [0..29]
      for j in [0..29]
        if @tiles[i][j].occupiedBy is unit
          @tiles[i][j].occupiedBy = null
    @removeChild(unit)
   
  # Reset tiles 
  reset: () ->
    for i in [0..29]
      for j in [0..29]
        @tiles[i][j].removeChild @attRangePoly
        @tiles[i][j].removeChild @moveRangePoly
        #TODO: remove character selection from the control panel. The easiest way to do this is to move the instance of cPanel in game.coffee into this file

  
    
