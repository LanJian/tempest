class window.CPanel extends Component
  
  # h - height of the scene
  # w - width of the scene
  constructor: (@h, @w) ->
    super()
    @init() 
      
  init: ->
    @bgImage = new Coffee2D.Image 'img/dota2CP.png'
    @bgImage.setSize @w,@w*0.18
    @bgImage.setPosition 0, @h-@w*0.18
    
    #Item panel to hold user items
    @ip = new ItemPanel
    @ip.setSize @w,@w*0.18
    @ip.setPosition 585, @h-@w*0.18 + 50

    
    console.log @bgImage
    console.log @ip
    
    @addChild @bgImage
    @addChild @ip 
    
 

