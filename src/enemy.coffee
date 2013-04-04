
class window.Enemy extends Agent
  constructor: ->
    super()

  makeMoveForUnit: (unit) ->
    if unit.actionTokens < 1
      return 'none'

    battle = Common.battleField
    minDist = 1000
    closestUnit = null

    for playerUnit in Common.player.units
      if unit.actionTokens > 0
        #console.log 'have actionTokens'
        if unit.canAttack playerUnit
          #console.log 'attack unit', unit, playerUnit
          battle.unitAttack unit, playerUnit
          return 'attack'

      dist = unit.onTile.distanceTo playerUnit.onTile
      if dist < minDist
        minDist = dist
        closestUnit = playerUnit

    if (unit.moveTokens > 0) and (closestUnit != null)
      console.log unit, closestUnit
      emptyTile = battle.findEmptyTile closestUnit.onTile, unit
      if emptyTile != null
        row = emptyTile.row
        col = emptyTile.col
        console.log 'Empty Tile', emptyTile, row, '--', col

        #onsole.log 'move unit', row, col
        battle.moveUnit unit, row, col
        return 'move'

    return 'none'


  makeMoves: () ->
    if (@units.length == 0) or (Common.player.units.length == 0)
      Common.state.endTurn()
      return

    # make a move every 3 seconds cuz i'm too lazy to implement proper callbacks
    i = 0
    madeMove = false
    id = setInterval (( ->
      console.log 'action Complete', Common.actionComplete
      if Common.actionComplete
        unit = @units[i]
        madeMove = @makeMoveForUnit unit
        while madeMove == 'none'
          i++
          if i >= @units.length
            #console.log '(&*^(&( end interval'
            Common.state.endTurn()
            clearInterval id
            return
          unit = @units[i]
          madeMove = @makeMoveForUnit unit
    ).bind this), 3000

