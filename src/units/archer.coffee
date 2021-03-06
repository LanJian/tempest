class window.Archer extends Unit
  constructor: (@row, @col, @enemy = false) ->
    
    spriteSheet = 'img/units/archer.png'
    if @enemy
      spriteSheet = 'img/units/archerEnemy.png'
    charSpriteSheet = new SpriteSheet spriteSheet, [
      # Idle
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
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
      # Got Hit
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64}         
    ]
    
    stats =
      name: "Archer"
      hp: 4
      moveRange: 8
      evasion: 0.1
      skill: 1
      cost: 1

    super charSpriteSheet, stats, null, null, 'img/units/archerProfile.png', @row, @col, @enemy

  setRow: (r) ->
    @row = r
  
  init: ->
    @cfg = [5,7,5,5]

    super()
    @equip Assets.longbow
    
