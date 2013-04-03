class window.ActionPanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    @buttonSize
    @selectedUnit
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)

    # Polygon for debugging 
    poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    poly.color = 'rgba(240,20,50,0.4)'
    @addChild poly
    @init()
    @updatePanel()
    

  init: () ->
    @buttonSize = {w: 30, h: 30}

    # Attack button    
    @attackButton = new Coffee2D.Image 'img/icons/attackIcon.png'
    @attackButton.setSize @buttonSize.w, @buttonSize.h
    @attackButton.setPosition 0, 0
     
    @attackButton.addListener 'click', ((evt) ->
      #TODO:Add action when clicked
      if @state.mode != 'unitMoving'
        newEvt = {type:'selectAttackTarget', from: @selectedUnit}
        @dispatchEvent newEvt
    ).bind this
    
    @addChild @attackButton
    
  updatePanel: ->
    if (Common.selected instanceof Unit) && (Common.selected.belongsTo is Common.player)
      #console.log 'Common blepng', Common.selected
      @show()
    else
      @hide()
        
    
