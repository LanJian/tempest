class window.Main extends Component
  
  # h - height of the scene
  # w - width of the scene
  #constructor: (@w, @h, @state) ->
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)

    # Create logo
    @logo = new Coffee2D.Image 'img/logo.png'
    @logo.setSize @size.w*0.8, @size.h*0.3
    @logo.setPosition @size.w*0.2/2, 0
    @addChild @logo
    
    # Add Start Button 
    @addButton (@size.w - 200) /2, 500, 200, 100,{
      normal: 'img/buttons/start.png',
      onhover: 'img/buttons/startHover.png'},(() -> 
      console.log 'clicked'
    )
    
  # Method for adding button
  # x, y, w, h - position/size of the button
  # icon {normal,onhover} - icon file for button
  # onclick - callback function for clicking
  addButton: (x, y, w, h, icon, onclick) ->
    # Create button
    @startButton = new Coffee2D.Image icon.normal
    @startButton.setSize w, h
    @startButton.setPosition 0,0
    
    @startButtonH = new Coffee2D.Image icon.onhover
    @startButtonH.setSize w, h
    @startButtonH.setPosition 0,0
    
    @startButtonH.hide()
    
    # Create rectangle
    @rec = new Rect x, y, w, h
    console.log @rec
    @rec.color = 'black'
    @rec.addChild @startButton
    @rec.addChild @startButtonH
    
    @addListener 'mouseMove', ((evt) ->
      if @rec.isPointInside evt.x, evt.y
        @startButtonH.show()
      else
        @startButtonH.hide()
    ).bind this

    @startButton.addListener 'click', (() ->
      Common.game.startBattle()
    ).bind this

    @addChild @rec


  


