class window.Audios extends Component

  # Central class to hold all audio objects
  constructor: () ->
    Common.audios = this
    @init()

  init: ->
    @switching = new Audio "audio/switch.mp3"
    @hurt = new Audio "audio/hurt.mp3"