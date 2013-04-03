class window.Archer extends Unit
  constructor: (@row, @col, @enemy = false) ->
    
    spriteSheet = 'img/units/archer.png'
    if @enemy
      spriteSheet = 'img/soldierEnemy.png'
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
      {length: 6, cellWidth: 64, cellHeight: 64},
      {length: 7, cellWidth: 64, cellHeight: 64},
      {length: 6, cellWidth: 64, cellHeight: 64},
      {length: 7, cellWidth: 64, cellHeight: 64},

      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64}         
    ]
    


    stats =
      name: "Archer"
      hp: 5
      moveRange: 10
      evasion: 0.1
      skill: 5
      cost: 1

    super charSpriteSheet, stats, null, null, 'img/soldierProfile.png', @row, @col

  setRow: (r) ->
    @row = r
  
  init: ->
    super()
    @equip Assets.longbow
    