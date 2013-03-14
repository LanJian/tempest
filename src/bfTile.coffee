class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    @addListener 'click',( ->
      console.log 'clicked', @occupiedBy
      newEvt = {type:'selectedUnit', @occupiedBy}
      @dispatchEvent newEvt
      ).bind this

  
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
      

    
