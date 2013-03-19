class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type, @state) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    if (@row + @col) < 37
      @addListener 'click', @onClick.bind this


  onClick: (evt) ->
    switch @state.mode
      when 'select'
        console.log 'select', this
        type = if @occupiedBy and @occupiedBy instanceof Unit then 'unitSelected' else 'tileSelected'
        newEvt = {type:type, target: @occupiedBy}
        @dispatchEvent newEvt
      when 'attack'
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
      when 'attack'
        console.log 'attack event'

  
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