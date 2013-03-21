class window.LoadoutPanel extends Component

  # panel used to hold items icon
  constructor: (@w, @h, @loadoutItems) ->
    super()
    @iconSize = {w:30, h:30}
    @init()
    @debug()
    

  init: ->
    # Setup Control Panel background image
    @bgImage = new Coffee2D.Image 'img/loadoutPanel.png'
    @bgImage.setSize @w, @h
    @addChild @bgImage  
    @display()

  debug: ->
    console.log 'Size', @size
    # Polygon for debugging 
    @poly = new Polygon [[0,0], [0,@h], [@w,@h], [@w,0]]
    #@addChild @poly

  display: ->
    x = 0
    if @loadoutItems
      for item in @loadoutItems
        console.log 'add item'
        icon = new Coffee2D.Image item.iconFile
        icon.setSize @iconSize.w, @iconSize.h
        icon.setPosition x, 5
        @addChild icon 
        x += @iconSize.w  + 10
