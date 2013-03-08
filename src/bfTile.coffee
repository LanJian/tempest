class window.BFTile extends Tile
  constructor: (@spritesheet, @index, @row, @col, @heightOffset=0) ->
    super @spritesheet, @index, @heightOffset
    @occupiedBy = null
    @init()

  init: ->
    @addListener 'click',( ->
      console.log 'clicked', @occupiedBy).bind this
