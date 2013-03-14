$(document).ready ->
  init()

fullSreen = (canvas) ->
  if canvas.webkitRequestFullScreen
    canvas.webkitRequestFullScreen()
  else
    canvas.mozRequestFullScreen()

init = ->
  # Make a scene
  canvas = $('#canvas')[0]

  $('#fs').on 'click', -> fullSreen canvas

  scene = new Scene canvas, 'black'

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

  map = []
  for i in [0..29]
    map[i] = []
    for j in [0..29]
      #map[i][j] = new Tile spriteSheet, 1, 32
      map[i][j] = new BFTile spriteSheet, 1, i, j, 32

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

  isoMap = new IsometricMap
    spriteSheet      : spriteSheet
    tiles            : map
    tileWidth        : 64
    tileHeight       : 64
    tileXOffset      : 32
    tileYOffset      : 16
    tileBoundingPoly : poly

  isoMap.setPosition -500, -300


  battle = new BattleField isoMap

  # Create user control panel
  cp = new CPanel 450, 800
  
  scene.addChild battle
  scene.addChild cp 

  #charSpriteSheet = new SpriteSheet 'img/char.png', [
    #{length: 8, cellWidth: 50, cellHeight: 50},
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
    #{length: 8, cellWidth: 50, cellHeight: 50}
  #]

  #charSprite = new Sprite charSpriteSheet
  #charSprite.addAnimation {id: 'bottomRight', row: 0, fps: 10}
  #charSprite.play 'bottomRight'
  #charSprite.setPosition 50, 160
  #scene.addChild charSprite

  #charSprite2 = new Sprite charSpriteSheet
  #charSprite2.addAnimation {id: 'walk', row: 2, fps: 10}
  #charSprite2.play 'walk'
  #charSprite2.setPosition 150, 100
  #scene.addChild charSprite2


  #isoMap.addObject(sprite3, 2, 0)

  #isoMap.position.x += 100
