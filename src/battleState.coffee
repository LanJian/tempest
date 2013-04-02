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
      t = new Coffee2D.Text 'Enemy Turn', 'blue', '40px Arial'
      t.setPosition 280, 500
      Common.game.floatText t
      @enemy.resetTokens()
      @enemy.makeMoves()
    else if @turn == @enemy
      @turn = @player
      t = new Coffee2D.Text 'Your Turn', 'blue', '40px Arial'
      t.setPosition 290, 500
      Common.game.floatText t
      @player.resetTokens()
      #@player.initiativePoints++
      Common.battleField.setPlayerIP @player, (Common.battleField.getPlayerIP(@player) + 1)
      console.log 'init points', @player.initiativePoints

  changeToMode: (mode) ->
    @mode = mode
    #Common.game.battleLog "Mode: #{mode}"
    #Common.cPanel.updatePanel()
    switch @mode
      when 'select'
        Common.game.changeCursor 'cursor/select.cur'
      when 'attack'
        Common.game.changeCursor 'cursor/attack.cur'
