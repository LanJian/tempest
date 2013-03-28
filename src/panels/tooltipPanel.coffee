class window.TooltipPanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    
    console.log 'Add Tooltip'
    @init()
    @hide()

  init: ->
    #Add Background Image
    @initBackground()
    @addListener 'updateTooltip', ((evt) ->
      if evt.item?
        @reset()
        hpText = new Coffee2D.Text "Name: #{evt.item.name}", 'red', '13px Arial'
        console.log "Name: #{evt.item.name}"
        hpText.setPosition 0, 20
        @addChild hpText
        console.log 'Display tooltip'
        @show()  
      else
        @hide()
    ).bind this

  reset: ->
     @children = [@bgImage]
     
  initBackground: ->  
    @bgImage = new Coffee2D.Image 'img/tooltipBG.png'
    @bgImage.setSize @size.w, @size.h
    @addChild @bgImage
    
