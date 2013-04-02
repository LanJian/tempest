class window.CPanel extends Component
  
  # h - height of the scene
  # w - width of the scene
  #constructor: (@w, @h, @state) ->
  constructor: (@panelPosition, @panelSize, @state) ->
    Common.cPanel = this
    @userPanel = []    
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    @init()
    @updatePanel()

  init: ->    
    @initBackground()
    @initItemPanel()
    @initLoadoutPanel()
    @initActionPanel()
    @initStatsPanel()
    @initProfilePanel()
    @children = @children.concat(@userPanel)
    
  initBackground: ->
    @bgImage = new Coffee2D.Image 'img/HUD.png'
    @bgImage.setSize @size.w, @size.h
    @addChild @bgImage
    
  initProfilePanel: ->
    # Setup action panel for user to initiate actions
    @pp = new ProfilePanel {x:@size.w * 0.022, y: @size.h * 0.13}, {w:@size.w * 0.14, h: @size.h * 0.85}
    @userPanel.push @pp
    
  initItemPanel: ->
    # Setup item panel used to display armors/weapons
    @ip = new ItemPanel {x:@size.w * 0.45, y: @size.h * 0.3}, {w:@size.w * 0.55, h: @size.h * 0.7}, @state
    @userPanel.push @ip
    
  initStatsPanel: ->
    # Setup action panel for user to initiate actions
    @sp = new StatsPanel {x:@size.w * 0.18, y: @size.h * 0.3}, {w:@size.w * 0.12, h: @size.h * 0.7}, @state
    @userPanel.push @sp
    
  initActionPanel: ->
    # Setup action panel for user to initiate actions
    @ap = new ActionPanel {x:@size.w * 0.32, y: @size.h * 0.3}, {w:@size.w * 0.1, h: @size.h * 0.7}, @state
    @userPanel.push @ap
    
  initLoadoutPanel: ->
    # Setup loadout panel used to display items
    @lp = new LoadoutPanel {x:@size.w * 0.2, y:0}, {w:@size.w * 0.8, h: @size.h * 0.3}
    @userPanel.push @lp
    item = []
    #for [1..15]
    armor = new Armor {
      name: "Knight Plate Armor"
      cost: 2
      defence: 1
      }, null, 'img/item1.png'
    armor2 = new Armor {
      name:  "Knight Plate Armor"
      cost: 2
      defence: 1
      }, null, 'img/item2.png'
    
    weapon3 = new Weapon {
      name:  "Long Sword1"
      cost: 2
      range: 1
      power: 1
      parry: 0.2
    }, null, 'img/item2.png'

    #armor3 = new Armor "Knight Plate Armor3", 2, 1, null, 'img/item3.png'
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]
    

    for i in [0..3]
      console.log 'createNew Soldier'
      soldier = new Soldier 20,20
      item.push soldier


    item.push armor
    item.push armor2
    item.push weapon3
    
    Common.loadout = item

  initLoad: ->
    for i in [0..3]
      console.log 'createNew Soldier'
      soldier = new Soldier 20,20
      item.push soldier


    item.push armor
    item.push armor2
    
    Common.loadout = item

  
  updatePanel: ->
    for panel in @userPanel
      panel.updatePanel()         

