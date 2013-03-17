class window.CPanel extends Component
  
  # h - height of the scene
  # w - width of the scene
  constructor: (@h, @w) ->
    
    # Panel width should be calculated from scene width + height
    @panelWidth = @w
    @panelHeight = @w * 0.18
    
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
    console.log '--'
    console.log @itemPanelSize

    # Setup item panel used to display armors/weapons
    @ip = new ItemPanel @itemPanelSize.w , @itemPanelSize.h
    @ip.setSize @itemPanelSize.w, @itemPanelSize.h
    @ip.setPosition @panelWidth - @padding.right - @itemPanelSize.w , @padding.top
    
    # Setup action panel for user to initiate actions
    @ap = new ActionPanel @itemPanelSize.w , @itemPanelSize.h
    
    @ap.setSize @itemPanelSize.w, @itemPanelSize.h
    @ap.setPosition @panelWidth - @padding.right - 2 * @itemPanelSize.w, @padding.top

    
    console.log @bgImage
    console.log @ip
    
    
   
    
    # Listener for unit select
    @addListener 'unitSelected', ((evt) ->      
      # Reset panel to display only permenant UI components  
      @selectedUnit = evt.target    
      profileIcon = new Coffee2D.Image @selectedUnit.iconFile
      profileIcon.setSize 100, 130
      profileIcon.setPosition 10, 10
    
      @addChild profileIcon
      @ip.updateItemPanel @selectedUnit
    ).bind this
        
    
    
    @addChild @bgImage
    @addChild @ip 
    @addChild @ap
    
  clear: ->
      @children = []   
