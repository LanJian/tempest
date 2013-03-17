class window.ItemPanel extends Component
  
  # panel used to hold items icon
  constructor: (@w, @h) ->
    super()
    
    @buttonSize = {w: 20, h: 20}
    @iconSize = {w:35, h:35}

    @selectedUnit
    
    # Init window to show weapons
    @windowSize = 3
    @weaponWindowIndex = {beginI: 0, endI: @windowSize-1}
    # Init window to show armors
    @armorWindowIndex = {beginI: 0, endI: @windowSize-1}

    



    # Used to store all permnant UI components
    @permUI = []
    @init()
    @addListener 'unitSelected', ((evt) ->
      @selectedUnit = evt.target
      # Reset panel to display only permenant UI components
      @updateItemPanel @selectedUnit   
    ).bind this
        
  init: ->
    # Buttons
    @leftArrow = new Coffee2D.Image 'img/leftArrow.png'
    @leftArrow.setSize @buttonSize.w, @buttonSize.h
    @leftArrow.setPosition @w - 3*@iconSize.w - 40 - 2*@buttonSize.w , @h - @buttonSize.h
    
    @rightArrow = new Coffee2D.Image 'img/rightArrow.png'
    @rightArrow.setSize @buttonSize.w, @buttonSize.h 
    @rightArrow.setPosition @w - @buttonSize.w , @h - @buttonSize.h
    
    @permUI.push @rightArrow
    @permUI.push @leftArrow
    
    @children = @permUI
  
    
    
    @leftArrow.addListener 'click', ((evt) ->
      if (@selectedUnit.armors)
        if (@armorWindowIndex.beginI - @windowSize >=0 )
          @armorWindowIndex.beginI -= @windowSize
          @armorWindowIndex.endI -= @windowSize   
          @updateItemPanel(@selectedUnit)

    ).bind this
    
    
    @rightArrow.addListener 'click', ((evt) ->
      if (@selectedUnit.armors)
        if (@armorWindowIndex.beginI + @windowSize < @selectedUnit.armors.length)
          @armorWindowIndex.beginI += @windowSize
          @armorWindowIndex.endI += @windowSize   
          @updateItemPanel(@selectedUnit)
    ).bind this
      
    # Polygon for debugging 
    @poly = new Polygon [[0,0], [0,@h], [@w,@h], [@w,0]]
    @addChild @poly  
    
  # Update item panel 
  updateItemPanel: (unit) -> 
    @children = []
    for c in @permUI
       @children.push c
    x =  @w - @buttonSize.w - 3 * @iconSize.w  - 30
    if unit.armors
      window = unit.armors[@armorWindowIndex.beginI..@armorWindowIndex.endI]
      for armor in window
        icon = new Coffee2D.Image armor.iconFile
        icon.setSize @iconSize.w, @iconSize.h
        icon.addListener 'click', ((evt) ->
           console.log 'item clicked' , icon
        ).bind this
        
        icon.setPosition x, @h / 2
        @addChild icon
        x = x + icon.size.w + 10

      console.log window
      console.log @children

      x =  @w - @buttonSize.w - 3 * @iconSize.w  - 30
      if unit.weapons
        window = unit.weapons[@weaponWindowIndex.beginI..@weaponWindowIndex.endI]
        for weapon in window
          icon = new Coffee2D.Image weapon.iconFile
          icon.setSize @iconSize.w, @iconSize.h
          icon.addListener 'click', ((evt) ->
             console.log 'item clicked' , icon
          ).bind this
          
          icon.setPosition x, 0
          @addChild icon
          x = x + icon.size.w + 10
      
        

          
   
    
 

