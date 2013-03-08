class window.Unit extends BFObject
  constructor: (@charSpriteSheet,@hp,@currenthp=@hp,@move,@skill,@evasion,@weapons,@armours) ->
    super()
    @init()

  init: ->
    # TODO shouldn't instantiate units here
    sprite = new Sprite @charSpriteSheet
    sprite.addAnimation {id: 'idle', row: 0, fps: 24}
    sprite.play 'idle'
    sprite.setSize 30, 45
    @addChild sprite
