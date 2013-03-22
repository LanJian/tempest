class window.LoadoutPanel extends Component

  # panel used to hold items icon
  constructor: (@w, @h, @loadoutItems) ->
    Common.loadoutPanel = this
    super()
    @iconSize = {w:30, h:30}
    @init()
    @debug()
    

  init: ->
    # Setup Control Panel background image
    @bgImage = new Coffee2D.Image 'img/loadoutPanel.png'
    @bgImage.setSize @w, @h
    @addChild @bgImage  
    @refresh()

  debug: ->
    console.log 'Size', @size
    # Polygon for debugging 
    @poly = new Polygon [[0,0], [0,@h], [@w,@h], [@w,0]]
    #@addChild @poly

  refresh: ->
    @children = []
    # Hardcoded Start position
    x = 30
    if @loadoutItems
      for i in [0...@loadoutItems.length]
        item = @loadoutItems[i]
        icon = new Coffee2D.Image item.iconFile
        icon.setSize @iconSize.w, @iconSize.h
        icon.setPosition x, 5
        icon.addListener 'click', @makeListener item
        console.log 'item', item
        @addChild icon 
        x += @iconSize.w  + 10
        
  makeListener: (item) ->
    return ( -> @onIconClicked item).bind this
  
  onIconClicked: (item) ->
    myitem = item
    console.log 'loadout item clicked' , myitem
    Common.game.battleLog 'add item', myitem
    # generate event to select target
    newEvt = {type:'loadoutSelectTarget', item: myitem}
    @dispatchEvent newEvt
    
  # Remove an item from the loadout panel  
  remove: (item) ->
     @loadoutItems.remove item
     @refresh()
    
