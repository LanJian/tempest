class window.StatsPanel extends Component
  
  # panel used to hold items icon
  constructor: (@panelPosition, @panelSize, @state) ->
    super(@panelPosition.x, @panelPosition.y, @panelSize.w, @panelSize.h)
    @selectedUnit
    @init()
  
    # Polygon for debugging 
    @poly = new Polygon [[0,0], [0,@size.h], [@size.w,@size.h], [@size.w,0]]
    @poly.color = 'rgba(240,20,50,0.4)'
    @addChild @poly
      
  init: ->

  updatePanel: ->
    # TODO: Display more stats
    if Common.selected instanceof Unit
      unit = Common.selected
      # TODO: Maybe a better way to do this?
      @children = []
      hpText = new Coffee2D.Text "HP: #{unit.curhp}/#{unit.stats.hp}", 'blue', '13px Verdana'
      hpText.setPosition 0, 20 
      
      powerText = new Coffee2D.Text "Evasion: #{unit.stats.evasion}", 'black', '13px Verdana'
      #console.log 'Font', powerText
      powerText.setPosition 0, 40  
      
      skillText = new Coffee2D.Text "Skill: #{unit.stats.skill}",'red', '13px Verdana'
      skillText.setPosition 0, 60 
      
      @addChild hpText
      @addChild powerText
      @addChild skillText
      @show()
    else
      @hide()


    
    
    
    