class window.BattleState
  constructor: (@player, @enemy) ->
    @mode = 'select'
    @turn = null
    @type = 'normal'
    @init()

  init: ->


  endTurn: ->
    console.log 'end turn'
    if @turn == @player
      @turn = @enemy
      @enemy.resetTokens()
      @enemy.makeMoves()
    else if @turn == @enemy
      @turn = @player
      @player.resetTokens()

  changeToMode: (mode) ->
    @mode = mode
    switch @mode
      when 'select'
        Common.game.changeCursor 'cursor/heros.cur'
      when 'attack'
        Common.game.changeCursor 'cursor/attack.cur'
