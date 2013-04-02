class window.LoadoutPanel extends Component

  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @loadoutItems) ->
    Common.loadoutPanel = this
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    @iconSize = {w:30, h:30}
    @permUI = []

    @init()
    @debug()
  
  init: ->
    @initBackground()
    @initText()
    
  initBackground: ->
    @bgImage = new Coffee2D.Image 'img/loadoutBackground.png'
    @bgImage.setSize @panelSize.w, @panelSize.h
    @permUI.push @bgImage
  
  initText: ->
    @ipText = new Coffee2D.Text "IP: #{Common.battleField.getPlayerIP(Common.player)}", 'blue', '20px Verdana'
    @ipText.setPosition 10, 25
    @permUI.push @ipText
    
    @addListener 'ipValueChange', (()->
      #console.log Common.battleField.getPlayerIP(Common.player)
      #console.log 'ipcahgne'
      @removeChild @ipText
      @ipText =  new Coffee2D.Text "IP: #{Common.battleField.getPlayerIP(Common.player)}", 'blue', '20px Verdana'
      @ipText.setPosition 10, 25
      @addChild @ipText
    ).bind this
      
  debug: ->
    #console.log 'Size', @size
    # Polygon for debugging 
    #@poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    #@addChild @poly

  updatePanel: ->
    @children = []
    for c in @permUI
      @children.push c
    #@addChild @bgImage, ipText
    # Hardcoded Start position
    console.log 'Loadout ', Common.loadout
    x = 140
    @loadoutItems = Common.loadout
    if @loadoutItems
      for i in [0...@loadoutItems.length]
        item = @loadoutItems[i]
        if item.iconFile
          icon = new Coffee2D.Image item.iconFile
        else
          icon = new Coffee2D.Image 'img/icons/default.png'
        icon.setSize @iconSize.w, @iconSize.h
        icon.setPosition x, 5
        # When user click 
        icon.addListener 'click', @clickListener item
  
        ##console.log 'item', item
        @addChild icon
        x += @iconSize.w  + 10
        
  clickListener: (item) ->
    return ( -> @onIconClicked item).bind this

  onIconClicked: (item) ->
    myitem = item
    #console.log 'loadout item clicked' , myitem
    # generate event to display tool tip
    tooltipEvt = {type:'updateTooltip', item: item}
    @dispatchEvent tooltipEvt
    # generate event to select target
    newEvt = {type:'loadoutSelectTarget', item: myitem}
    @dispatchEvent newEvt
    
 
    
