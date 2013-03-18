class window.BattleField extends IsometricMap
  constructor: (opts, @state) ->
    super opts

    @selectedUnit = null
    @curTile = null

  init: () ->
    console.log 'BattleField init'
    super()

    #TODO: hardcoded two units 
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]

    unit = new Unit charSpriteSheet, {
      name: "Black Commander 1"
      hp: 100
      move: 5
      evasion: 0.1
      skill: 30
    }, 'img/head.png'

    @addObject(unit, 10, 10)
    @tiles[10][10].occupiedBy = unit
    
    #Create new Armor/Weapon and equip
    armor = new Armor "Knight Plate Armor", 2, 1, null, 'img/item1.png'
    armor2 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item2.png'
    armor3 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item3.png'
    weapon = new Weapon "Poison­Tipped Sword", 2, 1, 1, 0.2, null, 'img/item2.png'

    #for i in [0..2]
    unit.equip(armor)
    unit.equip(armor2)
    unit.equip(armor3)
    unit.equip(armor)
    unit.equip(weapon)

    console.log unit
     

    unit2 = new Unit charSpriteSheet, {
      name: "Black Commander 2"
      hp: 100
      move: 5
      evasion: 0.1
      skill: 30
    }, null

    for i in [0..2]
      unit2.equip(armor3)

    @addObject(unit2, 11, 10)
    @tiles[11][10].occupiedBy = unit2

    
    
    
    #@findPath @map, @size, @start, @end
    @addListener 'unitSelected', ((evt) ->
      @selectedUnit = evt.target
      console.log 'Selected Unit', @selected
      @curTile = evt.origin
      @state.mode = 'move'
    ).bind this

    @addListener 'unitMove', ((evt) ->
      console.log 'unitmove event'
      u = @selectedUnit
      tile = @tiles[@curTile.row][evt.col]
      finalTile = @tiles[evt.row][evt.col]
      console.log "move to tile", tile
      tween = u.moveTo tile

      tween.onComplete ( ->
       console.log "move to tile 2", finalTile
       t = u.moveTo finalTile
       t.onComplete ( ->
         console.log 'tweenFinished'
         u.sprite.play 'idle'
       ).bind this
      ).bind this

      @curTile.occupiedBy = null
      @curTile = finalTile
      finalTile.occupiedBy = u
      console.log 'Final tile', @selectedUnit
    ).bind this

    #@addListener 'tweenFinished', ((evt) ->
      #console.log 'tweenFinished'
      #@selectedUnit.sprite.play 'idle'
    #).bind this


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
        return
      evt.target = this

    if evt.type == 'click'
      for child in @children
        # transform event coordinates
        evt.x = evt.x - child.position.x
        evt.y = evt.y - child.position.y
        child.handle evt
        # untransform event coordinates
        evt.x = evt.x + child.position.x
        evt.y = evt.y + child.position.y

    for listener in @listeners
      if evt.type == listener.type
        listener.handler evt
    
   
  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (map, size, start, end) ->
      
