class window.ActionPanel extends Component
  
  # panel used to hold items icon
  constructor: (@w, @h) ->
    super()
    @buttonSize = {w: 30, h: 30}
    @init()
    # Polygon for debugging 
    poly = new Polygon [[0,0], [0,@h], [@w,@h], [@w,0]]
    @addChild poly
    

  init: () ->
    
    
    # Move button    
    @moveButton = new Coffee2D.Image 'img/moveIcon.png'
    @moveButton.setSize @buttonSize.w, @buttonSize.h 
    @moveButton.setPosition 0, 0
    
    
    # Attack button    
    @attackButton = new Coffee2D.Image 'img/attackIcon.png'
    @attackButton.setSize @buttonSize.w, @buttonSize.h 
    @attackButton.setPosition @buttonSize.w + 10 , 0
    
    
    # Add listeners
    @moveButton.addListener 'click', ((evt) ->
      #TODO:Add action when clicked
    )
    
    @attackButton.addListener 'click', ((evt) ->
      #TODO:Add action when clicked
    )
    
    @addChild @attackButton
    @addChild @moveButton
    
    
    