class window.Dialog extends Component
  
  # h - height of the scene
  # w - width of the scene
  #constructor: (@w, @h, @state) ->
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    @init()
    

  init: ->
    @turn = "A"
    @indexA = 0
    @indexB = 0
    @dialogA = ["Hi",
                "How are you?",
                "Not Bad either",
                ""]
    
    @dialogB = ["Hi",
                "Not Bad. you?",
                "Not Bad",
                "",
                ""]
    @textA
    @textB

    # Create Left Person Image    
    @personA = new Coffee2D.Image 'img/personA.jpg'
    @personA.setSize 150, 200
    @personA.setPosition 600, 300
    @addChild @personA
    console.log @personA
    
    # Create Right Person Image   
    @personB = new Coffee2D.Image 'img/personB.jpg'
    @personB.setSize 150, 200
    @personB.setPosition 50, 300
    @addChild @personB
    console.log @personA
    
    
    
    # Add previous Button 
    @addButton 20, 550, 130, 65,{
      normal: 'img/buttons/prev.png',
      onhover: 'img/buttons/prevH.png'},(() -> 
      console.log 'clicked'
      Common.game.startBattle()
    ).bind this
    
    # Add Next Button 
    @addButton 670 , 550, 130, 65,{
      normal: 'img/buttons/next.png',
      onhover: 'img/buttons/nextH.png'},(() -> 
      console.log 'clicked'
      @next()
    ).bind this
    
    # Add Skip Button 
    @addButton  700 , 620, 70, 30,{
      normal: 'img/buttons/skip.png',
      onhover: 'img/buttons/skipH.png'},(() -> 
      console.log 'clicked'
      Common.game.startBattle()
    ).bind this
    
    
    
    
  next: ->
    
    if @turn is "A"
      @removeChild @textA
      console.log 'text', @dialogA
      @textA = new Coffee2D.Text @dialogA[@indexA], 'red', '30px Arial'
      @textA.setPosition 100, 100
      @addChild @textA
      @indexA += 1
      @turn = "B"
    else
      @removeChild @textB
      console.log 'text', @dialogB
      @textB = new Coffee2D.Text @dialogB[@indexB], 'red', '30px Arial'
      @textB.setPosition 300, 100
      @addChild @textB
      @indexB += 1 
      @turn = "A"
        
  displayDialog: ->
    if @turn is "A"
      @removeChild @textA 
    
  # Method for adding button
  # x, y, w, h - position/size of the button
  # icon {normal,onhover} - icon file for button
  # onclick - callback function for clicking
  addButton: (x, y, w, h, icon, onclick) ->
    # Create button
    button = new Coffee2D.Image icon.normal
    button.setSize w, h
    button.setPosition 0,0
    
    buttonH = new Coffee2D.Image icon.onhover
    buttonH.setSize w, h
    buttonH.setPosition 0,0
    
    buttonH.hide()
    
    # Create rectangle
    rec = new Rect x, y, w, h
    console.log @rec
    rec.color = "rgba(0,0,0,0)"
    rec.addChild button
    rec.addChild buttonH
    
    @addListener 'mouseMove', ((evt) ->
      if rec.isPointInside evt.x, evt.y
        buttonH.show()
      else
        buttonH.hide()
    ).bind this

    button.addListener 'click', onclick

    @addChild rec
