class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0, @type) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    @addListener 'click',( ->
      console.log 'clicked', @occupiedBy).bind this

  
  onContact: (unit) ->
    switch @type
      when "" then
      else
     
    
  onLeave: (unit) ->
    switch @type
      when "" then
      else
      

    
