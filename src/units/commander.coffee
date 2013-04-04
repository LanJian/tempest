class window.Commander extends Unit
  constructor: (@row, @col,  @enemy = false) ->
    spriteSheet = 'img/units/commander.png'
    if @enemy
      spriteSheet = 'img/units/commanderEnemy.png'
          
    charSpriteSheet = new SpriteSheet spriteSheet, [
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
      {length: 8, cellWidth: 64, cellHeight: 64},
      {length: 8, cellWidth: 64, cellHeight: 64},
      {length: 8, cellWidth: 64, cellHeight: 64},
      {length: 8, cellWidth: 64, cellHeight: 64},
      
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64}         
    ]
    


    stats =
      name: "Commander"
      hp: 10
      moveRange: 8
      evasion: 0.1
      skill: 4
      cost: 99

    super charSpriteSheet, stats, null, null, 'img/units/commanderProfile.png', @row, @col, @enemy

  setRow: (r) ->
    @row = r
  
  init: ->   
    super()
    @equip Assets.longSword
    