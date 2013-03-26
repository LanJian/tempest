
class window.Enemy extends Agent
  constructor: ->
    super()

  makeMoves: () ->
    battle = Common.battleField
    for unit in @units
      minDist = 1000
      closestUnit = null
      for playerUnit in Common.player.units
        dist = unit.onTile.distanceTo playerUnit.onTile
        if dist < minDist
          minDist = dist
          closestUnit = playerUnit

      console.log closestUnit.onTile
      emptyTile = battle.findEmptyTile closestUnit.onTile, unit
      console.log 'emptyTile', emptyTile
      row = emptyTile.row
      col = emptyTile.col
      battle.moveUnit unit, row, col
