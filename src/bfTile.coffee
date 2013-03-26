class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type, @state) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    @addListener 'click', @onClick.bind this


  distanceTo: (target) ->
    return Math.abs(target.row - @row) + Math.abs(target.col - @col)


  onClick: (evt) ->
    switch @state.mode
      when 'select'
        switch @state.type
          when 'normal'
            console.log 'select', this
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
