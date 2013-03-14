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

    @map.addObject(unit2, 1, 0)
    @map.tiles[1][0].occupiedBy = unit2

    @addListener 'unitSelected', ((evt) ->
      unit = evt.target
      @selectedUnit = unit
      @curTile = evt.origin
      @state.mode = 'move'
      #unit.animateTo {position: {x: unit.position.x+200}}, 3000
    ).bind this

    @addListener 'unitMove', ((evt) ->
      tile = @map.tiles[evt.row][evt.col]
      p = tile.position
      @selectedUnit.animateTo {position: p}, 3000
      @curTile.occupiedBy = null
      tile.occupiedBy = @selectedUnit
      @curTile = tile
    ).bind this
