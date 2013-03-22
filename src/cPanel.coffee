class window.CPanel extends Component
  
  # h - height of the scene
  # w - width of the scene
  constructor: (@h, @w, @state) ->
    
    # Panel width should be calculated from scene width + height
    @panelWidth = @w
    @panelHeight = @w * 0.18
    @userPanel = []
    @padding = {top: 50 , bottom:10 , left: 0, right: 20}
    super()
    @init()
    # Position of the control panel
    @position = {x: 0, y: @h - @panelHeight}
  
    # Keep track of selected unit
    @selectedUnit
      
  init: ->    
    # Setup Control Panel background image
    @bgImage = new Coffee2D.Image 'img/cpBackground.png'
    @bgImage.setSize @w,@w*0.18
    @bgImage.setPosition 0, 0 
    
   
    @itemPanelSize = { w: @panelWidth* 0.3, h: @panelHeight - @padding.top - @padding.bottom }
    @loadoutPanelSize = {w: @panelWidth, h: @panelHeight * 0.3} 


    # Setup item panel used to display armors/weapons
    @ip = new ItemPanel @itemPanelSize.w , @itemPanelSize.h, @state
    @ip.setSize @itemPanelSize.w, @itemPanelSize.h
    @ip.setPosition @panelWidth - @padding.right - @itemPanelSize.w , @padding.top
    
    item = []
    #for [1..15]
    armor = new Armor "Knight Plate Armor", 2, 1, null, 'img/item1.png'
    armor2 = new Armor "Knight Plate Armor2", 2, 1, null, 'img/item2.png'
    #armor3 = new Armor "Knight Plate Armor3", 2, 1, null, 'img/item3.png'
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]
    
    for i in [0..20]
      unit = new Unit charSpriteSheet, {
        name: "Black Commander 2"
        hp: 100
        moveRange: 5
        evasion: 0.1
        skill: 30
      }, null, 'img/item3.png'
    
      witem.push unit
    item.push armor
    item.push armor2
    
    #item.push armor3

    # Setup loadout panel used to display items
    @lp = new LoadoutPanel @loadoutPanelSize.w, @loadoutPanelSize.h, item
    @lp.setSize @loadoutPanelSize.w, @loadoutPanelSize.h
    @lp.setPosition 130, 0
    
    
    # Setup action panel for user to initiate actions
    @ap = new ActionPanel @itemPanelSize.w , @itemPanelSize.h, @state
    @ap.setSize @itemPanelSize.w, @itemPanelSize.h
    @ap.setPosition @panelWidth - @padding.right - 2 * @itemPanelSize.w, @padding.top
    console.log @bgImage
    console.log @ip
    @reset()
 
    # Listener for unit select
    @addListener 'unitSelected', ((evt) ->      
      # Reset panel to display only permenant UI components  
      @selectedUnit = evt.target    
      @reset
      profileIcon = new Coffee2D.Image @selectedUnit.iconFile
      profileIcon.setSize 100, 130
      profileIcon.setPosition 10, 10
    
      @addChild profileIcon
      @ip.updateItemPanel @selectedUnit
      @ap.selectedUnit = @selectedUnit
      @displayUserPanel()
    ).bind this
    
    # Listener for tile select
    @addListener 'tileSelected', ((evt) ->       
      console.log 'tile selected'
      @reset()
    ).bind this    

  # Display user control panel
  displayUserPanel: ->
    @addChild @ip
    @addChild @ap
    @addChild @lp

   
  # Reset the control panel to display only background image 
  reset: ->
    @children = []
    @addChild @lp
    @addChild @bgImage
      
