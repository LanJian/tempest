class window.Agent
  constructor: ->
    @units = []

  addUnit: (unit) ->
    @units.push unit
    unit.belongsTo = this

  resetTokens: ->
    for unit in @units
      unit.moveTokens = 1
      unit.actionTokens = 1

  removeUnit: (unit) ->
    @units.remove unit
