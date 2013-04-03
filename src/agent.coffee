class window.Agent
  constructor: ->
    @units = []

  addUnit: (unit) ->
    #console.log 'Adding Unit', unit
    @units.push unit
    unit.belongsTo = this
    #console.log 'Unit belongs to ', unit.belongsTo

  resetTokens: ->
    for unit in @units
      unit.moveTokens = 1
      unit.actionTokens = 1

  removeUnit: (unit) ->
    @units.remove unit
