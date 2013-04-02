$(document).ready ->
  game = new Game()

fullSreen = (canvas) ->
  if canvas.webkitRequestFullScreen
    canvas.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT)
  else
    canvas.mozRequestFullScreen()

class window.Game
  constructor: ->
    Common.game = this
    @scene = null
    @battleLogs = []
    @init()

  init: ->
    # Fullscreen
    $('#fs').on 'click', -> fullSreen canvas
    
    # Make a scene
    canvas = $('#canvas')[0]
    @sceneSize = {w: canvas.width, h: canvas.height}
    @scene = new Scene canvas, 'black'
    Common.scene = @scene
    
    # Register listeners
    @scene.addListener 'bfObjectReady', ((evt) ->
      console.log 'obj ready', evt.target.size
      #obj = evt.target
      #@addObject obj, obj.row, obj.col
    ).bind this
        
        
    # init all scene screens/sound Effects
    @initSounds()
    @initMain()
    @initDialog()
    @initHelp()
    @initTootip()


    
    # Main enterpoint is main screen
    #@start()
    @initBattle()
    @startBattle()
    #@startDialog()
    return 0

#---------------------------------------------------------------------------------------------------
# Switch Scene functions
#---------------------------------------------------------------------------------------------------    
  start: ->
    @startMain()
    
  startHelp: ->
    @reset()
    @scene.addChild @help
    
  startDialog: ->
    @reset()
    @scene.addChild @dialog

  startBattle: ->
    @reset()
    @audios.bgMusic.play()
    @initBattle()
    @initCPanel()
    @scene.addChild @battle
    @scene.addChild @cp
    @scene.addChild @tooltip
 
  startMain: ->
    @reset()
    @scene.addChild @main
#---------------------------------------------------------------------------------------------------
# Initialize functions
#---------------------------------------------------------------------------------------------------
   
  # Initialize sound effects
  initSounds: ->
    @audios = new Audios  
    
  # Initialize help scene
  initHelp: ->
    @help = new Help {x:0, y: 0}, {w:@sceneSize.w, h: @sceneSize.h}
  
  # Initialize c panel (need to initialize battlefield first)
  initCPanel: ->
    # Create user control panel
    @cp = new CPanel {x:0, y: @sceneSize.h *0.8 }, {w:@sceneSize.w, h: @sceneSize.h *0.2}, Common.state
      
  # Initialize main scene
  initMain: ->
    @main = new Main {x:0, y: 0}, {w:@sceneSize.w, h: @sceneSize.h}
  
  # Initialize tooltip panel
  initTootip: ->
    @tooltip = new TooltipPanel {x:@sceneSize.w*0.8, y: 0}, {w:@sceneSize.w*0.2, h:@sceneSize.h*0.2}

  # Initialize dialog scene
  initDialog: ->
    # Starts with a main screen
    @dialog = new Dialog {x:0, y: 0}, {w:@sceneSize.w, h: @sceneSize.h}
    
  # Initialize battle ground
  initBattle: ->

    # Make player and enemy
    #Create new Armor/Weapon and equip    
    armor = new Armor {
      name: "Knight Plate Armor"
      cost: 2
      defence: 1
      }, null, 'img/item2.png'
    armor2 = new Armor {
      name: "Knight Plate Armor"
      cost: 2
      defence: 1
      }, null, 'img/item2.png'
    armor3 = new Armor {
      name:  "Knight Plate Armor"
      cost: 2
      defence: 1
      }, null, 'img/item3.png'
    weapon = new Weapon {
      name: "Poison­Tipped Sword"
      cost: 2
      range: 1
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'
    weapon1 = new Weapon {
      name: "Long Bow"
      type: 'bow'
      cost: 2
      range: 10
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'
    weapon2 = new Weapon {
      name:  "Long Sword"
      cost: 2
      range: 1
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'
    weapon3 = new Weapon {
      name:  "Long Sword"
      cost: 2
      range: 1
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'

    unit = new Commander 11, 11
    unit.equip(armor)
    unit.equip(armor2)
    unit.equip(armor3)
    unit.equip(weapon1)
    unit.equip(weapon)
    console.log 'w', unit.weapons

    unit2 = new Soldier 11, 10
    unit2.equip(armor3)
    
    unit3 = new Archer 11, 14
    unit3.equip(armor3)

    @player = new Player()
    @player.addUnit unit
    @player.addUnit unit2
    @player.addUnit unit3
    @enemy = new Enemy()

    unit3 = new Soldier 13, 10, true
    unit3.equip weapon2
    unit4 = new Soldier 17, 17, true
    unit4.equip weapon3
    @enemy.addUnit unit3
    @enemy.addUnit unit4

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
    console.log 'Map', map
    console.log 'Commmon', Common
    console.log 'Common.state', Common.state.mode
    console.log 'Map', Common.mapLayer1.length
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

    console.log map

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
    building = new SpriteImage buildingsSS, 0
    building2 = new SpriteImage buildingsSS, 4
    building3 = new SpriteImage buildingsSS, 2
    @battle.addObject (new BFObject castle, 7, 7), 0, 11
    @battle.addObject (new BFObject building, 4, 4), 5, 20
    @battle.addObject (new BFObject building2, 4, 4), 20, 5

    @battle.setPosition -500, -300

  # Reset the scene to have nothing
  reset: ->
    #TODO: not to use hard coded reset
    bg = new Rect 0, 0, @scene.size.w, @scene.size.h, 'black'
    @scene.children = [bg]
    
  changeCursor: (cursorFile) ->
    canvas.style.cursor = "url(#{cursorFile}), default"
    console.log "Style", canvas.style
    

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
