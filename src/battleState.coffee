class window.BattleState
  constructor: (@player, @enemy) ->
    @mode = 'select'
    @turn = null
    @type = 'normal'
    @init()

  init: ->

  endTurn: ->
    console.log 'end turn'
    # Game ends when either side loses all units
    
    if @player.units.length <= 0
        console.log 'Game OVER'
        Common.game.endGame 'defeat'
        return
    if @enemy.units.length <= 0
        Common.game.endGame 'victory'
        return

    if @turn == @player
      @turn = @enemy
      t = new Coffee2D.Text 'Enemy Turn', 'blue', '40px Arial'
      t.setPosition Common.cPanel.position.x+300, Common.cPanel.position.y - 10
      Common.game.floatText t
      @enemy.resetTokens()
      @enemy.makeMoves()
    else if @turn == @enemy
      @turn = @player
      t = new Coffee2D.Text 'Your Turn', 'blue', '40px Arial'
      t.setPosition Common.cPanel.position.x+350, Common.cPanel.position.y - 10
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
