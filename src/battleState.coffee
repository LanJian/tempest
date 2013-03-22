class window.BattleState
  constructor: () ->
    @mode = 'select'
    @turn = null
    @init()

  init: ->
