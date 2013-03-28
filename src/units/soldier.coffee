
class window.Soldier extends Unit
  constructor: (@row, @col) ->
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]

    stats =
      name: "Soldier"
      hp: 5
      moveRange: 5
      evasion: 0.1
      skill: 5

    super charSpriteSheet, stats, null, null, 'img/head.png'
