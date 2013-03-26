class window.LoadoutPanel extends Component

  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @loadoutItems) ->
    Common.loadoutPanel = this
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    @iconSize = {w:30, h:30}
    @init()
    @debug()
    

  init: ->
    @initBackground()

  initBackground: ->
    @bgImage = new Coffee2D.Image 'img/loadoutBackground.png'
    @bgImage.setSize @panelSize.w, @panelSize.h
    @addChild @bgImage

  debug: ->
    console.log 'Size', @size
    # Polygon for debugging 
    #@poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    #@addChild @poly

  updatePanel: ->
    @children = []
    @addChild @bgImage
    # Hardcoded Start position
    x = 30
    @loadoutItems = Common.loadout
    if @loadoutItems
      for i in [0...@loadoutItems.length]
        item = @loadoutItems[i]
        console.log '-------------item', item
        icon = new Coffee2D.Image item.iconFile
        icon.setSize @iconSize.w, @iconSize.h
        icon.setPosition x, 5
        # When user click 
        icon.addListener 'click', @clickListener item
  
        #console.log 'item', item
        @addChild icon 
        x += @iconSize.w  + 10
        
  clickListener: (item) ->
    return ( -> @onIconClicked item).bind this

  
  onIconClicked: (item) ->
    myitem = item
    console.log 'loadout item clicked' , myitem
    Common.game.battleLog 'add item', myitem
    # generate event to select target
    newEvt = {type:'loadoutSelectTarget', item: myitem}
    @dispatchEvent newEvt
    
 
    
