class window.ActionPanel extends Component
  
  # panel used to hold items icon
  constructor: (@w, @h, @state) ->
    @buttonSize
    @selectedUnit
    super()

    @init()
    # Polygon for debugging 
    poly = new Polygon [[0,0], [0,@h], [@w,@h], [@w,0]]
    @addChild poly
    

  init: () ->    
    @buttonSize = {w: 30, h: 30}
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
    ).bind this
    
    @attackButton.addListener 'click', ((evt) ->
      console.log 'attack clicked', @state.mode
      #TODO:Add action when clicked
      # Only when game mode is in select
      #Jack Huang: this is supposed to be move right?
      if @state.mode is 'move'
        newEvt = {type:'selectAttackTarget', from: @selectedUnit}
        console.log 'unit Attack', @selectedUnit
        @dispatchEvent newEvt
    ).bind this
    
    @addChild @attackButton
    @addChild @moveButton
    
    
    
