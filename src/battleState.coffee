class window.BattleState
  constructor: () ->
    @mode = 'select'
    @turn = null
    @type = 'normal'
    @init()

  init: ->
