class window.BattleField extends Component
  constructor: (@map, @state) ->
    super()
    @init()
    @addChild @map

    @selectedUnit = null
    @curTile = null

  init: () ->
    #TODO: hardcoded two units 
    charSpriteSheet = new SpriteSheet 'img/hibiki.png', [
      {length: 25, cellWidth: 67, cellHeight: 97},
      {length: 12, cellWidth: 67, cellHeight: 101}
    ]
    
    charSpriteSheet1 = new SpriteSheet 'img/spriteSheet1.png', [
      {length: 3, cellWidth: 50, cellHeight: 70}
      {length: 3, cellWidth: 50, cellHeight: 70}
    ]

    unit = new Unit charSpriteSheet1, "Soldier", 100, 5, 0.1, null, 'img/head.png'

    @map.addObject(unit, 10, 10)
    @map.tiles[10][10].occupiedBy = unit
    
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
     

    unit2 = new Unit charSpriteSheet, "Samurai", 100, 5, 0.1, null, null, null

    for i in [0..2]
      unit2.equip(armor3)

    @map.addObject(unit2, 11, 10)
    @map.tiles[11][10].occupiedBy = unit2

    @highlightRange unit2, 5
    
    
    #@findPath @map, @size, @start, @end
    @addListener 'unitSelected', ((evt) ->
      unit = evt.target
      @selectedUnit = unit
      console.log 'Selected Unit', @selected
      @curTile = evt.origin
      @state.mode = 'move'
    ).bind this

    @addListener 'unitMove', ((evt) ->
      tile = @map.tiles[@curTile.row][evt.col]
      finalTile = @map.tiles[evt.row][evt.col]
      tween = @selectedUnit.moveTo tile

      tween.onComplete ( ->
        @selectedUnit.moveTo finalTile
      ).bind this

      @curTile.occupiedBy = null
      @curTile = finalTile
      finalTile.occupiedBy = @selectedUnit
      console.log 'Final tile', @selectedUnit
    ).bind this
    
    
    # Listener for units attack
    @addListener 'selectAttackTarget', ((evt) ->
      # Show attack range
      @state.mode = 'attack'
    ).bind this
    
    @addListener 'unitAttack', ((evt) ->
      # Check Range
      # Perform attack
      @selectedUnit.attack evt.target
      #console.log 'Attack unit from' , @selectedUnit , 'to', evt.target
      @state.mode = 'select'
    ).bind this


    @addListener 'tweenFinished', ((evt) ->
      console.log 'tweenFinished'
      @selectedUnit.sprite.play 'idle'
    ).bind this
    
   
  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (size, start, end) ->
    
    
  highlightRange: (unit, range) ->
    pos = {x: 0, y: 0}
    for i in [0..29]
      for j in [0..29]    
        if @map.tiles[i][j] is unit 
          pos.x = i
          pos.y = j
                 
    for i in [0...@map.tiles.length-1]
      row = @map.tiles[i]
      for j in [0...row.length-1]
        tile = row[j]
        if @inRange(pos, {x:i, y:j}, unit.move)
          tile.showPoly()
             
  inRange: (curPos, tarPos, range) ->
    diffX = Math.abs(tarPos.x - curPos.x)
    diffY = Math.abs(tarPos.y - curPos.y)
    return (diffX <= range) and (diffY <= range)
