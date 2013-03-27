class window.Tooltip extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    
    console.log 'Add Tooltip'
    @init()  

  init: ->
    #Add Background Image
    @initBackground()
    @addListener 'updateTooltip', ((evt) ->
      if evt.item?
        @show()
        hpText = new Coffee2D.Text "", 'red', '13px Arial'
        console.log "asdf\n}"
        hpText.setPosition 0, 20
        @addChild hpText
        console.log 'Display tooltip'
      else
        @hide()
    ).bind this

  
  initBackground: ->  
    @bgImage = new Coffee2D.Image 'img/tooltipBG.png'
    @bgImage.setSize @size.w, @size.h
    @addChild @bgImage
    
