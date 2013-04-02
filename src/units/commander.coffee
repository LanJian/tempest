class window.Commander extends Unit
  constructor: (@row, @col) ->
    charSpriteSheet = new SpriteSheet 'img/soldier.png', [
      # Idle
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 1, cellWidth: 64, cellHeight: 64},
      # Walk
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      # Attack
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64}
    ]
    


    stats =
      name: "Commander"
      hp: 500
      moveRange: 20
      evasion: 0.1
      skill: 5
      cost: 1

    super charSpriteSheet, stats, null, null, 'img/commanderProfile.png', @row, @col

  setRow: (r) ->
    @row = r
  
  init: ->
    super()
    