class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type, @state) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    @addListener 'click', @onClick.bind this


  onClick: (evt) ->
    console.log 'clicked', @occupiedBy
    switch @state.mode
      when 'select'
        if @occupiedBy
          newEvt = {type:'unitSelected', target: @occupiedBy}
          @dispatchEvent newEvt
      when 'move'
        newEvt =
          type:'unitMove'
          row: @row
          col: @col
        @dispatchEvent newEvt
      


  
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
