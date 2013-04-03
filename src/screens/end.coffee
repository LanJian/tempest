class window.End extends Component
  
  # h - height of the scene
  # w - width of the scene
  #constructor: (@w, @h, @state) ->
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    
    # Create background Image
    @bgVic = new Coffee2D.Image 'img/background/victory.png'
    @bgVic.setSize @size.w, @size.h
    @bgVic.setPosition 0,0
   
    # Create background Image
    @bgDef = new Coffee2D.Image 'img/background/defeat.png'
    @bgDef.setSize @size.w, @size.h
    @bgDef.setPosition 0,0    
    
    
    @selected = null

    
  setMessage: (message) ->
    ##console.log 'SEt Message'
    if message == 'victory'
       @addChild @bgVic
    else 
       @addChild @bgDef


    # Add Menu Button 
    @addButton (@size.w - 200) /2, 480, 130, 65,{
      normal: 'img/buttons/restart.png',
      onhover: 'img/buttons/restartH.png'},(() ->
         window.location.reload(true);
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
    #console.log @rec
    rec.color = "rgba(0,0,0,0)"
    rec.addChild button
    rec.addChild buttonH
    
    @addListener 'mouseMove', ((evt) ->
      if rec.isPointInside evt.x, evt.y
        buttonH.show()
        if @selected != button
          Common.audios.switching.play()
          @selected = button
      else
        @selected = null
        buttonH.hide()
    ).bind this

    button.addListener 'click', onclick

    @addChild rec


  


