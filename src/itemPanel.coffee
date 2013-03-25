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
    
  # Update item panel 
  updatePanel: ->
    console.log 'update'
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
      
    icon.setSize @iconSize.w, @iconSize.h
    icon.setPosition position.x, position.y
    icon.addListener 'click', @clickListener item

    console.log 'Add Icon', icon
    @addChild icon

  clickListener: (item) ->
    return ( -> @onIconClicked item).bind this

  onIconClicked: (item) ->
    console.log item
    