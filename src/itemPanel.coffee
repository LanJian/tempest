class window.ItemPanel extends Component
  
  # panel used to hold items icon
  constructor: (@h, @w) ->
    super()
    @init() 
        
    @addListener 'selectedUnit', ((evt) ->
      selected = evt.occupiedBy
      console.log selected
      @children = []
      @pos = {x:0, y:0}
      if (selected)
        if (selected.armors) 
         for armor in selected.armors
          console.log 'draw icon'  
          icon = new Coffee2D.Image armor.icon
          icon.setSize 40, 40
          icon.setPosition @pos.x, @pos.y
          @addChild icon 
          @pos.x +=50
          if (@pos.x > 100)
            @pos.x = 0
            @pos.y = 45
          
    ).bind this
        
  init: ->

    
    

    
   
    
 

