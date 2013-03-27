class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type, @state) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @move = 1
    @init()

  init: ->
    @addListener 'click', @onClick.bind this
    # TODO: add more types
    switch @type
      when 'water'
        @move = 3
    
  distanceTo: (target) ->
    return Math.abs(target.row - @row) + Math.abs(target.col - @col)

  onClick: (evt) ->
    # TODO: Might be a better place to put this
    tooltipEvt = {type:'updateTooltip'}
    @dispatchEvent tooltipEvt
    
    switch @state.mode
      when 'select'
        switch @state.type
          when 'normal'
            type = if @occupiedBy and @occupiedBy instanceof Unit then 'unitSelected' else 'tileSelected'
            Common.selected = @occupiedBy
            Common.cPanel.updatePanel()
            newEvt = {type:type, target: @occupiedBy}
            @dispatchEvent newEvt
          when 'loadout'
            newEvt = {type:'applyLoadout', target: @occupiedBy}
            @dispatchEvent newEvt
      when 'attack'
        console.log 'dispatch attack'
        newEvt = {type:'unitAttack', target: @occupiedBy}
        @dispatchEvent newEvt
      when 'move'
        console.log 'move event'
        newEvt =
          type:'unitMove'
          row: @row
          col: @col
        @dispatchEvent newEvt
        @state.mode = 'select' #TODO: change this?

  
  onContact: (unit) ->
    #TODO: add effects
    switch @type
      when "" then
      else
     
    
  onLeave: (unit) ->
    #TODO: add effects
    switch @type
      when "" then
      else
