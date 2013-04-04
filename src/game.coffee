$(document).ready ->
  game = new Game()

fullSreen = (canvas) ->
  Common.game.doFullScreen()

class window.Game
  constructor: ->
    Common.game = this
    @scene = null
    @battleLogs = []
    @inFullScreen = false
    @seenResize = false
    @init()


  doFullScreen: ->
    if @canvas.webkitRequestFullScreen
      @canvas.width = screen.width 
      @canvas.height = screen.height 
      @sceneSize = {w: canvas.width, h: canvas.height}
      @resize()
      @canvas.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT)
    else
      @canvas.mozRequestFullScreen()

  exitFullScreen: ->
    @canvas.width = 800
    @canvas.height = 650
    @sceneSize = {w: canvas.width, h: canvas.height}
    @resize()


  resize: ->
    console.log 'resize'
    @scene.removeChild @main
    @scene.removeChild @end
    @scene.removeChild @tooltip
    @initTootip()
    @scene.addChild @tooltip
    
    if Common.screen == 'battle'
      @scene.removeChild @cp
      @initCPanel()
      @scene.addChild @cp
      
    @initMain()
    @initEnd()

    if Common.screen == 'main'
      @scene.addChild @main
    if Common.screen == 'end'
      @scene.addChild @end
    # TODO: this is hacky
    @scene.children[0].size = @sceneSize

  init: ->
    #$(window).bind 'resize', ((e) ->
    #  if @seenResize
    #    @seenResize = false
    #    return
    #  @inFullScreen = !@inFullScreen
    #  if !@inFullScreen
    #    @exitFullScreen()
    #  @seenResize = true
    #).bind this

    # Fullscreen
    $('#fs').on 'click', -> fullSreen @canvas
    
    # Make a scene
    @canvas = $('#canvas')[0]
    @sceneSize = {w: @canvas.width, h: @canvas.height}
    @scene = new Scene @canvas, 'black'
    Common.scene = @scene

    # Register listeners
    @scene.addListener 'bfObjectReady', ((evt) ->
      #console.log 'obj ready', evt.target.size
      #obj = evt.target
      #@addObject obj, obj.row, obj.col
    ).bind this
        
        
    # init all scene screens/sound Effects
    @initSounds()
    @initMain()
    @initHelp()
    @initTootip()
    @initEnd()
    
    # Main enterpoint is main screen
    @start()
    #@initBattle()
    #@startBattle()
    return 0

#---------------------------------------------------------------------------------------------------
# Switch Scene functions
#---------------------------------------------------------------------------------------------------    
  start: ->
    Common.screen = 'main'
    @startMain()
    
  startHelp: ->
    Common.screen = 'help'
    @reset()
    @scene.addChild @help
    
  startBattle: ->
    Common.screen = 'battle'
    @reset()
    @audios.bgMusic.play()
    @initBattle()
    @initCPanel()
    @scene.addChild @battle
    @scene.addChild @cp
    @scene.addChild @tooltip
  
  endGame: (message) ->
    Common.screen  = 'end'
    @reset()
    @end.setMessage message
    @scene.addChild @end
    
  startMain: ->
    @reset()
    @scene.addChild @main
#---------------------------------------------------------------------------------------------------
# Initialize functions
#---------------------------------------------------------------------------------------------------
   
  # Initialize sound effects
  initSounds: ->
    @audios = new Audios  
  
  initEnd: ->
    @end = new End {x:0, y: 0}, {w:@sceneSize.w, h: @sceneSize.h}
    
  # Initialize help scene
  initHelp: ->
    @help = new Help {x:0, y: 0}, {w:@sceneSize.w, h: @sceneSize.h}
  
  # Initialize c panel (need to initialize battlefield first)
  initCPanel: ->
    console.log 'x', @sceneSize.w, 'h', @sceneSize.h*0.2
    # Create user control panel
    @cp = new CPanel {x: ((@sceneSize.w - 800) /2), y: (@sceneSize.h - 130 )}, {w: 800, h: 130}, Common.state
      
  # Initialize main scene
  initMain: ->
    @main = new Main {x: ((@sceneSize.w - 800) /2), y: ((@sceneSize.h - 650) /2)}, {w:800, h: 650}
  
  # Initialize tooltip panel
  initTootip: ->
    console.log '---',@sceneSize.w, ',', @sceneSize.h*0.2
    @tooltip = new TooltipPanel {x: (@sceneSize.w - 240), y: 0}, {w:240, h:130}

  # Initialize battle ground
  initBattle: ->
    # Init Players
    @player = new Player()
    @enemy = new Enemy()

    # Initlize Units
    #  Player Units  
    playerUnits = [
      (new Commander 36, 11)
      (new Soldier 38, 8)
      (new Soldier 38, 14)
      ]
      

    #  Enemy Units
    enemyUnits = [
      (new Commander 7, 14, true)
      (new Soldier 19, 10, true)
      (new Soldier 19, 11, true)
      (new Soldier 19, 12, true)
      (new Soldier 19, 13, true)
      (new Archer 21, 9, true)
      (new Archer 21, 15, true)
      (new Knight 8, 12, true)
      (new Knight 8, 16, true)
      ]

    for u in playerUnits
      @player.addUnit u
    for u in enemyUnits
      @enemy.addUnit u

    
    battleState = new BattleState @player, @enemy
    battleState.turn = @player
        
    Common.state = battleState
    Common.player = @player
    Common.enemy = @enemy
    Common.game = this
    
    @makeMap battleState

  makeMap: (battleState) ->
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
      {length: 10  , cellWidth: 64 , cellHeight: 64},
      {length: 10 , cellWidth: 64 , cellHeight: 64},
      {length: 10 , cellWidth: 64 , cellHeight: 64}
    ]

  
        
    map = []
    for i in [0...Common.mapSize.row]
      map[i] = []
      for j in [0...Common.mapSize.col]
        #map[i][j] = new Tile spriteSheet, 1, 32
        map[i][j] = new BFTile spriteSheet, 1, i, j, 32, '', battleState
    
     
    counter = 0
    #console.log 'Map', map
    #console.log 'Commmon', Common
    #console.log 'Common.state', Common.state.mode
    #console.log 'Map', Common.mapLayer1.length
    for d in Common.mapLayer1
      if d != 0    
        #console.log 'Add index', (counter%30), '--', (counter/30)
        tile = map[Math.floor(counter/Common.mapSize.col)][counter%Common.mapSize.col]
        tile.addHeightIndex (d - 321) 
        if (d - 321) in [80...110]
          tile.setType 'water'
          
      counter += 1
    
    #map[17][15].addHeightIndex 54

    #map[16][15].addHeightIndex 55
    #map[16][14].addHeightIndex 54
    #map[15][14].addHeightIndex 55
    #map[16][14].addHeightIndex 120

    #map[15][15].addHeightIndex 54
    #map[15][15].addHeightIndex 54
    #map[15][15].addHeightIndex 51

    #map[18][15].addHeightIndex 51
    #map[18][16].addHeightIndex 50
    #map[17][16].addHeightIndex 55

    #map[17][14].addHeightIndex 53

    #map[14][14].addHeightIndex 54

    ## waterfall
    #map[14][15].addHeightIndex 62
    #map[14][15].addHeightIndex 61
    #map[14][15].addHeightIndex 63

    ## grass
    #map[16][16].addHeightIndex 114
    #map[15][16].addHeightIndex 115

    ## pond
    #map[14][16].addHeightIndex 91
    #map[14][17].addHeightIndex 94

    #map[18][12].addHeightIndex 120
    #map[11][17].addHeightIndex 121

    #console.log map

    poly = new Polygon [[32,32], [64,48], [32,64], [0,48]]

    @battle = new BattleField (
      spriteSheet      : spriteSheet
      tiles            : map
      tileWidth        : 64
      tileHeight       : 64
      tileXOffset      : 32
      tileYOffset      : 16
      tileBoundingPoly : poly
    ), battleState, @player, @enemy
    Common.battleField = @battle

    buildingsSS = new SpriteSheet 'img/buildings.png', [
      {length: 6  , cellWidth: 256 , cellHeight: 329} ,
      {length: 1  , cellWidth: 455 , cellHeight: 480}
    ]

    castle = new SpriteImage buildingsSS, 6
    apartment = new SpriteImage buildingsSS, 0
    house = new SpriteImage buildingsSS, 2
    archeryRange = new SpriteImage buildingsSS, 3
    barracks = new SpriteImage buildingsSS, 4
    mill = new SpriteImage buildingsSS, 5
    @battle.addObject (new BFObject castle, 7, 7), 0, 11

    @battle.addObject (new BFObject apartment, 4, 4), 0, 18
    @battle.addObject (new BFObject house, 4, 4), 0, 22
    @battle.addObject (new BFObject apartment, 4, 4), 0, 26

    @battle.addObject (new BFObject house, 4, 4), 0, 0
    @battle.addObject (new BFObject apartment, 4, 4), 0, 4
    @battle.addObject (new BFObject apartment, 4, 4), 0, 8

    @battle.addObject (new BFObject house, 4, 4), 5, 19
    @battle.addObject (new BFObject apartment, 4, 4), 5, 25

    @battle.addObject (new BFObject house, 4, 4), 5, 5
    @battle.addObject (new BFObject apartment, 4, 4), 5, 0

    @battle.addObject (new BFObject archeryRange, 4, 4), 11, 25

    @battle.addObject (new BFObject mill, 4, 4), 11, 5
    @battle.addObject (new BFObject house, 4, 4), 11, 0

    @battle.addObject (new BFObject barracks, 4, 4), 17, 1

    @battle.addObject (new BFObject barracks, 4, 4), 17, 25

    @battle.setPosition -500, -300

  # Reset the scene to have nothing
  reset: ->
    #TODO: not to use hard coded reset
    bg = new Rect 0, 0, @scene.size.w, @scene.size.h, 'black'
    @scene.children = [bg]
    
  changeCursor: (cursorFile) ->
    canvas.style.cursor = "url(#{cursorFile}), default"
    #console.log "Style", canvas.style
    

  battleLog: (text) ->
    t = new Coffee2D.Text text, 'red', '15px Arial'
    @addBattleLog t
    setTimeout (( ->
      @removeBattleLog t
    ).bind this), 3000

  addBattleLog: (t) ->
    if @battleLogs.length >= 5
      @removeBattleLog @battleLogs[0]
    t.position.y = @battleLogs.length * 15 + 15
    @scene.addChild t
    @battleLogs.push t

  removeBattleLog: (t) ->
    @scene.removeChild t
    @battleLogs.remove t
    for i in [0...@battleLogs.length]
      l = @battleLogs[i]
      l.position.y = i*15 + 15

  floatText: (t) ->
    @scene.addChild t
    setTimeout (( ->
      @scene.removeChild t
    ).bind this), 3000
