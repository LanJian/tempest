
class window.Enemy extends Agent
  constructor: ->
    @actions = []
    super()

  makeMoveForUnit: (unit) ->
    if unit.actionTokens < 1
      return false

    battle = Common.battleField
    minDist = 1000
    closestUnit = null

    for playerUnit in Common.player.units
      if unit.actionTokens > 0
        console.log 'have actionTokens'
        if unit.canAttack playerUnit
          # attack an unit
          #@actions.push ((u, t) -> ( ->
            #console.log 'attack unit', u, t
            #battle.unitAttack u, t
          #))(unit, playerUnit)
          console.log 'attack unit', unit, playerUnit
          battle.unitAttack unit, playerUnit
          return true

      dist = unit.onTile.distanceTo playerUnit.onTile
      if dist < minDist
        minDist = dist
        closestUnit = playerUnit

    if unit.moveTokens > 0
      emptyTile = battle.findEmptyTile closestUnit.onTile, unit
      row = emptyTile.row
      col = emptyTile.col
      # move the unit
      #@actions.push ((u, r, c) -> ( ->
        #console.log 'move unit', r, c
        #battle.moveUnit u, r, c
      #))(unit, row, col)
      console.log 'move unit', row, col
      battle.moveUnit unit, row, col
      return true
    return false


  makeMoves: () ->
    if (@units.length == 0) or (Common.player.units.length == 0)
      endTurn()
      return

    @actions = []

    #for unit in @units
      #@makeMoveForUnit unit

    # make a move every 2 seconds cuz i'm too lazy to implement proper callbacks
    i = 0
    madeMove = false
    id = setInterval (( ->
      #console.log i, @actions.length
      #if i >= @actions.length
        #clearInterval id
        #return
      #move = @actions[i]
      #console.log 'call move'
      #move()
      #i++
      unit = @units[i]
      madeMove = @makeMoveForUnit unit
      while not madeMove
        i++
        if i >= @units.length
          console.log '(&*^(&( end interval'
          Common.state.endTurn()
          clearInterval id
          return
        unit = @units[i]
        madeMove = @makeMoveForUnit unit
    ).bind this), 2000

