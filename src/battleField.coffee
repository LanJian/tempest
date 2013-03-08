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

    unit = new Unit charSpriteSheet

    @map.addObject(unit, 0, 0)
    @map.tiles[0][0].occupiedBy = unit

    unit2 = new Unit charSpriteSheet

    @map.addObject(unit2, 1, 0)
    @map.tiles[1][0].occupiedBy = unit2


