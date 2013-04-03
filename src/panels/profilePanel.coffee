class window.ProfilePanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    
    @init()
      
  init: ->
    # Polygon for debugging 
    #@poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    #@poly.color = 'rgba(240,20,50,0.4)'
    #@addChild @poly
    # Add a frame
    @profileFrame = new Coffee2D.Image 'img/frame.png'
    @profileFrame.setSize @size.w, @size.h
    @addChild @profileFrame
    
  # Update profile panel 
  updatePanel: ->
    if Common.selected instanceof Unit
      unit = Common.selected
      @removeChild @profileFrame    
      @removeChild @profileImage
      @profileImage = new Coffee2D.Image unit.iconFile
      @profileImage.setSize @size.w - 22, @size.h - 20
      @profileImage.setPosition 11, 10
      @addChild @profileImage
      @addChild @profileFrame
      @show()
    else
      @hide()