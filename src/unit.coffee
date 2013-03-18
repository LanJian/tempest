class window.Unit extends BFObject
  # charSpriteSheet - spritesheet for the unit
  # hp - total hp of the unit
  # move - number of tiles unit can move
  # evasion - probability (from 0 to 1) a incoming attack is missed
  # skill - stat that determines the unit's evasion and attack
  # weapon - unit's equipped weapon
  # armors - unit's equipped set of armors
  constructor: (@charSpriteSheet, @stats, @onTile, @iconFile) ->

    @curhp = @stats.hp
    @weapon
    @armors = []

    
    super()
    @init()

  init: ->
    # TODO shouldn't instantiate units here
    @sprite = new Sprite @charSpriteSheet
    @sprite.addAnimation {id: 'idle', row: 0, fps: 24}
    @sprite.addAnimation {id: 'walk', row: 1, fps: 24}
    @sprite.play 'idle'
    @sprite.setSize 30, 45
    @addChild @sprite
    @setSize 30, 45

    
  # Move Unit to specified tile
  moveTo: (tile) ->
    @onTile = {col: tile.col, row: tile.row}
    # speed per mili
    speed = 0.2
    p = tile.position
    dist = Math.abs(p.x - @position.x) + Math.abs(p.y - @position.y)
    duration = dist / speed
    duration+=1 if duration==0
    tween = @animateTo {position: p}, duration
    @sprite.play 'walk'
    return tween
    
  # Equip unit with an item <weapon or armor>
  equip: (item) ->
    #TODO: add logic for cant equip item that already equipped
    #if item in @weapons
    #if item in @armors
    if (item instanceof Weapon)
      @weapon = item
    else if (item instanceof Armor)
      @armors.push item
      @defence += item.defence
    else
    
  # Unequip unit with an item
  unEquip: (item) ->
    #TODO: add logic for cant unEquip item that doenst exist
    if (item instanceof Weapon)
      # Remove effect
      @stats.parry -= item.parry if @parry >= item.parry
      @stats.power -= item.power if @power >= item.power
      @weapon = null
    else if (item instanceof Armor)
      @stats.defence -= item.defence if @defence >= item.defence
    else
    
    
  attack: (target) ->
    console.log 'unit attack'
    target.curhp -= @stats.skill
    
  # Use Skill on specified target
  useSkill: (skillType, target) ->
    #TODO: add Skills
    switch @type
      when "" then
      when "" then
      else

     
  
    
    
    
    
