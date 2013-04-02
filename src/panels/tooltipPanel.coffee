class window.TooltipPanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    
    #console.log 'Add Tooltip'
    @init()
    @hide()

  init: ->
    #Add Background Image
    @initBackground()
    @addListener 'updateTooltip', ((evt) ->
      if evt.item?
        @reset()
        y = 15
        for k,v of evt.item.stats
           statText = new Coffee2D.Text "#{k}: #{v}", 'red', '13px Verdana'
           statText.setPosition 30, y
           y += 15
           @addChild statText
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
    
