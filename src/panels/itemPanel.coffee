class window.ItemPanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
 
    @iconSize = {w:35, h:35}
    @selectedUnit
    @init()
      
  init: ->
    # Polygon for debugging 
    @poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    @poly.color = 'rgba(240,20,50,0.4)'
    @addChild @poly
    
    # Overlay Image used to dispaly selected weapon
    @overlay = new Coffee2D.Image 'img/selectionOverlay.png'
    @overlay.setSize @iconSize.w, @iconSize.h
    
  # Update item panel 
  updatePanel: ->
    @children = []
    if Common.selected instanceof Unit
      unit = Common.selected
      if unit?
        x = 0
        if unit.armors?
          for armor in unit.armors
            @addIcon {x: x, y: 50}, armor
            x = x + @iconSize.w + 10
        x = 0
        if unit.weapons?
          for weapon in unit.weapons
            @addIcon {x: x, y: 0}, weapon
            x = x + @iconSize.w + 10
      @show()
    else
      @hide()
       
  addIcon: (position, item) ->
    if item.iconFile?
      icon = new Coffee2D.Image item.iconFile
    else 
      icon = new Coffee2D.Image 'img/icons/default.png'
      
    if item is Common.selected.weaponActive  
      @overlay.children = []
      @overlay.setPosition position.x, position.y
      icon.setSize @iconSize.w - 10, @iconSize.h - 10
      icon.setPosition 5 ,5
      @overlay.addChild icon
      @addChild @overlay
    else  
      icon.setSize @iconSize.w, @iconSize.h
      icon.setPosition position.x, position.y
      @addChild icon
    icon.addListener 'click', @clickListener item


  clickListener: (item) ->
    return ( -> @onIconClicked item).bind this

  onIconClicked: (item) ->
    if item instanceof Weapon
      Common.selected.weaponActive = item
      @updatePanel()
      if Common.battleField.state.mode is 'attack'
        # Rehighlight in battle field
        Common.battleField.onSelectAttackTarget()
         # generate event to display tool tip
    tooltipEvt = {type:'updateTooltip', item: item}
    @dispatchEvent tooltipEvt  
    