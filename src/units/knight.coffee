class window.Knight extends Unit
  constructor: (@row, @col, @enemy = false) ->
    
    spriteSheet = 'img/units/knight.png'
    if @enemy
      spriteSheet = 'img/units/knightEnemy.png'
    charSpriteSheet = new SpriteSheet spriteSheet, [
      # Idle
      {length: 11, cellWidth: 64, cellHeight: 81},
      {length: 11, cellWidth: 64, cellHeight: 81},
      {length: 11, cellWidth: 64, cellHeight: 81},
      {length: 11, cellWidth: 64, cellHeight: 81},
      # Walk
      {length: 10, cellWidth: 64, cellHeight: 81},
      {length: 10, cellWidth: 64, cellHeight: 81},
      {length: 10, cellWidth: 64, cellHeight: 81},
      {length: 10, cellWidth: 64, cellHeight: 81},
      # Attack
      {length: 12, cellWidth: 64, cellHeight: 81},
      {length: 12, cellWidth: 64, cellHeight: 81},
      {length: 12, cellWidth: 64, cellHeight: 81},
      {length: 12, cellWidth: 64, cellHeight: 81},
      # Got Hit
      {length: 5, cellWidth: 64, cellHeight: 81},
      {length: 5, cellWidth: 64, cellHeight: 81},
      {length: 5, cellWidth: 64, cellHeight: 81},
      {length: 5, cellWidth: 64, cellHeight: 81}         
    ]
    


    stats =
      name: "Knight"
      hp: 8
      moveRange: 12
      evasion: 0.1
      skill: 2
      cost: 4

    super charSpriteSheet, stats, null, null, 'img/units/knightProfile.png', @row, @col, @enemy

  setRow: (r) ->
    @row = r
  
  init: ->  
    @cfg = [7,24,15,5]
    super()
    @equip Assets.lightSpear
    