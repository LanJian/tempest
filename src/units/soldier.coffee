
class window.Soldier extends Unit
  constructor: (@row, @col, @enemy = false) ->
    
    spriteSheet = 'img/units/soldier.png'
    if @enemy
      spriteSheet = 'img/units/soldierEnemy.png'
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
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64},
      {length: 2, cellWidth: 64, cellHeight: 64}   
      
    ]
    


    stats =
      name: "Soldier"
      hp: 6
      moveRange: 8
      evasion: 0.1
      skill: 1
      cost: 1

    super charSpriteSheet, stats, null, null, 'img/units/soldierProfile.png', @row, @col, @enemy

  setRow: (r) ->
    @row = r
  
  init: ->
    @cfg = [5,7,7,5]
    
    super()
    @equip Assets.sword
