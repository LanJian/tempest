class window.Main extends Component
  
  # h - height of the scene
  # w - width of the scene
  #constructor: (@w, @h, @state) ->
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)

    # Create background Image
    @logo = new Coffee2D.Image 'img/main.png'
    @logo.setSize @size.w, @size.h
    @logo.setPosition 0,0
    @addChild @logo
       
    # Add Start Button 
    @addButton (@size.w - 200) /2, 410, 130, 65,{
      normal: 'img/buttons/start.png',
      onhover: 'img/buttons/startH.png'},(() ->
      Common.game.reset() 
      Common.game.startBattle()
    ).bind this
    
    # Add Menu Button 
    @addButton (@size.w - 200) /2, 480, 130, 65,{
      normal: 'img/buttons/menu.png',
      onhover: 'img/buttons/menuH.png'},(() -> 
      # TODO: Add screen transition for Menu
    ).bind this
    
   
    # Add Help Button 
    @addButton (@size.w - 200) /2, 550, 130, 65,{
      normal: 'img/buttons/help.png',
      onhover: 'img/buttons/helpH.png'},(() -> 
      # TODO: Add screen transition for Help
    ).bind this
    
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


  


