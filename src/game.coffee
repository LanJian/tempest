$(document).ready ->
  game = new Game()

fullSreen = (canvas) ->
  if canvas.webkitRequestFullScreen
    canvas.webkitRequestFullScreen()
  else
    canvas.mozRequestFullScreen()

class window.Game
  constructor: ->
    @scene = null
    @init()

  init: ->
    # Make a scene
    canvas = $('#canvas')[0]

    $('#fs').on 'click', -> fullSreen canvas

    @scene = new Scene canvas, 'black'

    spriteSheet = new SpriteSheet 'img/tileset.png', [
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64} ,
      {length: 10  , cellWidth: 64 , cellHeight: 64} ,
      {length: 10 , cellWidth: 64 , cellHeight: 64},
      {length: 10 , cellWidth: 64 , cellHeight: 64}
    ]

    battleState = new BattleState()

    map = []
    for i in [0...30]
      map[i] = []
      for j in [0...30]
        #map[i][j] = new Tile spriteSheet, 1, 32
        map[i][j] = new BFTile spriteSheet, 1, i, j, 32, '', battleState

    map[17][15].addHeightIndex 54

    map[16][15].addHeightIndex 55
    map[16][14].addHeightIndex 54
    map[15][14].addHeightIndex 55
    map[16][14].addHeightIndex 120

    map[15][15].addHeightIndex 54
    map[15][15].addHeightIndex 54
    map[15][15].addHeightIndex 51

    map[18][15].addHeightIndex 51
    map[18][16].addHeightIndex 50
    map[17][16].addHeightIndex 55

    map[17][14].addHeightIndex 53

    map[14][14].addHeightIndex 54

    # waterfall
    map[14][15].addHeightIndex 62
    map[14][15].addHeightIndex 61
    map[14][15].addHeightIndex 63

    # grass
    map[16][16].addHeightIndex 114
    map[15][16].addHeightIndex 115

    # pond
    map[14][16].addHeightIndex 91
    map[14][17].addHeightIndex 94

    map[18][12].addHeightIndex 120
    map[11][17].addHeightIndex 121

    console.log map

    #poly = new Polygon [[32,32], [64,48], [32,64], [0,48]]
    poly = new Polygon [[32,32], [64,48], [32,64], [0,48]]

    battle = new BattleField (
      spriteSheet      : spriteSheet
      tiles            : map
      tileWidth        : 64
      tileHeight       : 64
      tileXOffset      : 32
      tileYOffset      : 16
      tileBoundingPoly : poly
    ), battleState

    battle.setPosition -500, -300


    #battle = new BattleField isoMap, battleState

    # Create user control panel
    cp = new CPanel 450, 800, battleState
    
    
    @scene.addChild battle
    @scene.addChild cp

    Common.game = this


  battleLog: (text) ->
    t = new Coffee2D.Text text, 'red', '13px Arial'
    t.setPosition 0, 10
    @scene.addChild t
    setTimeout (( ->
      console.log 'timed out'
      @scene.removeChild t
    ).bind this), 3000
