class window.Unit extends BFObject
  # charSpriteSheet - spritesheet for the unit
  # hp - total hp of the unit
  # move - number of tiles unit can move
  # evasion - probability (from 0 to 1) a incoming attack is missed
  # skill - stat that determines the unit's evasion and attack
  # weapon - unit's equipped set of weapons
  # armors - unit's equipped set of armors
  constructor: (@charSpriteSheet, @stats, @iconFile) ->

    @curhp = @hp
    @weapons = []
    @armors = []
    
    super()
    @init()

  init: ->
    # TODO shouldn't instantiate units here
    @sprite = new Sprite @charSpriteSheet
    @sprite.addAnimation {id: 'idle', row: 0, fps: 1}
    @sprite.addAnimation {id: 'walk-downleft', row: 1, fps: 10}
    @sprite.addAnimation {id: 'walk-upright', row: 2, fps: 10}
    @sprite.addAnimation {id: 'walk-downright', row: 3, fps: 10}
    @sprite.addAnimation {id: 'walk-upleft', row: 4, fps: 10}
    @sprite.play 'idle'
    #@sprite.setSize 30, 45
    @addChild @sprite
    #@setSize 30, 45

    
  # Move Unit to specified tile
  moveTo: (tile) ->
    # speed per mili TODO: magic number
    speed = 0.15
    p = tile.position

    # direction
    dir = 'downleft'
    console.log tile.row, tile.col
    if (tile.row < 11)
      dir = 'upright'
    else if (tile.col < 10)
      dir = 'upleft'
    else if (tile.col > 10)
      dir = 'downright'

    dist = Math.sqrt(Math.pow((p.x - @position.x), 2) + Math.pow((p.y - @position.y), 2))
    duration = dist / speed
    duration+=1 if duration==0
    tween = @animateTo {position: p}, duration
    console.log 'dir: ', dir
    @sprite.play 'walk-'+dir
    return tween
    
  # Equip unit with an item <weapon or armor>
  equip: (item) ->
    #TODO: add logic for cant equip item that already equipped
    #if item in @weapons
    #if item in @armors
    if (item instanceof Weapon)
      @weapons.push item
      # Add effect
      @parry += item.parry
      @power += item.power
    else if (item instanceof Armor)
     
      @armors.push item
      @defence += item.defence
    else
    
  # Unequip unit with an item
  unEquip: (item) ->
    #TODO: add logic for cant unEquip item that doenst exist
    if (item instanceof Weapon)
      # Remove effect
      @parry -= item.parry if @parry >= item.parry
      @power -= item.power if @power >= item.power
    else if (item instanceof Armor)
      @defence -= item.defence if @defence >= item.defence
    else
    
  # Use Skill on specified target
  useSkill: (skillType, target) ->
    #TODO: add Skills
    switch @type
      when "" then
      when "" then
      else

     
  
    
    
    
    
