class window.BattleField extends Component
  constructor: (@map) ->
    super()
    @init()
    @addChild @map

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
    armor = new Armor "Knight Plate Armor", 2, 1, null
    weapon = new Weapon "Poison­Tipped Sword", 2, 1, 1, 0.2, null
    unit.equip(armor)
    unit.equip(weapon)
    console.log unit

    unit2 = new Unit charSpriteSheet, "Black Commander", 100, 5, 0.1, null, null, null

    @map.addObject(unit2, 11, 10)
    @map.tiles[11][10].occupiedBy = unit2


