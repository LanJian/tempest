class window.BFObject extends Component
  constructor: (@sprite, @width=1, @height=1) ->
    super()
    @anchorY = 0
    @loaded = false
    @init()

  init: ->
    @addListener 'spriteImageLoaded', @onSpriteImageLoaded.bind this
    @addChild @sprite
  

  onSpriteImageLoaded: (evt) ->
    if @loaded or (not @sprite.hasSpriteSheet(evt.target))
      return
    console.log '()()()() bfObject loaded', this
    evt =
      type: 'bfObjectReady'
      origin: this
      target: this
    @dispatchEvent evt
    @loaded = true
