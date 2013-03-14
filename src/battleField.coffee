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

    unit = new Unit charSpriteSheet, "Black Commander", 100, 5, 0.1

    @map.addObject(unit, 10, 10)
    @map.tiles[10][10].occupiedBy = unit
    
    #Create new Armor/Weapon and equip
    armor = new Armor "Knight Plate Armor", 2, 1, null, 'img/item1.png'
    armor2 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item2.png'
    armor3 = new Armor "Knight Plate Armor", 2, 1, null, 'img/item3.png'
    weapon = new Weapon "Poison­Tipped Sword", 2, 1, 1, 0.2, null, 'img/item2.png'

    for i in [0..2]
      unit.equip(armor)
      unit.equip(armor)
      console.log unit
     

    unit2 = new Unit charSpriteSheet, "Black Commander", 100, 5, 0.1, null, null, null

    for i in [0..2]
      unit2.equip(armor3)

    @map.addObject(unit2, 9, 12)
    @map.tiles[9][12].occupiedBy = unit2
    
    #@findPath @map, @size, @start, @end
    
    @addListener 'unitSelected', ((evt) ->
      unit = evt.target
      @selectedUnit = unit
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
    ).bind this

    #@addListener 'tweenFinished', ((evt) ->
      #console.log 'tweenFinished'
      #@selectedUnit.sprite.play 'idle'
    #).bind this
    
  # map - map of the battle field
  # size - size of the map {w:<# of horizontal tiles>, h:<# of vertical tiles>}
  # start - start tile {x,y}
  # finish - end tile {x,y}
  findPath: (map, size, start, end) ->
      
