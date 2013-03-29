
class window.Soldier extends Unit
  constructor: (@row, @col) ->
    charSpriteSheet = new SpriteSheet 'img/unit.png', [
      {length: 1, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64},
      {length: 4, cellWidth: 64, cellHeight: 64}
    ]
    
    
    @charSpriteSheetAttack = new SpriteSheet 'sprites/attack.png', [
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64},
      {length: 3, cellWidth: 64, cellHeight: 64}
    ]


    stats =
      name: "Soldier"
      hp: 5
      moveRange: 5
      evasion: 0.1
      skill: 5

    super charSpriteSheet, stats, null, null, 'img/head.png'
    @init()
  
  init: ->
    super()
    @sprite.addSpriteSheet 'attack', @charSpriteSheetAttack    
    @sprite.addAnimation {spriteSheetId: 'attack', id:'attack-downleft', row: 0, fps: 2}
    @sprite.addAnimation {spriteSheetId: 'attack', id:'attack-upright', row: 1, fps: 2}
    @sprite.addAnimation {spriteSheetId: 'attack', id:'attack-downright', row: 2, fps: 2}
    @sprite.addAnimation {spriteSheetId: 'attack', id:'attack-upleft', row: 3, fps: 2}   
    console.log 'add sprite', @sprite       