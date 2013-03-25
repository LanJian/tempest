class window.BattleState
  constructor: (@player, @enemy) ->
    @mode = 'select'
    @turn = null
    @type = 'normal'
    @init()

  init: ->


  endTurn: ->
    if @turn == @player
      @turn = @enemy
    if @turn == @enemy
      @turn = @player
