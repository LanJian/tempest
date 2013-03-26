class window.Unit extends BFObject
  # charSpriteSheet - spritesheet for the unit
  # hp - total hp of the unit
  # moveRange - number of tiles unit can move
  # evasion - probability (from 0 to 1) a incoming attack is missed
  # skill - stat that determines the unit's evasion and attack
  # weapon - unit's equipped weapon
  # armors - unit's equipped set of armors
  constructor: (@charSpriteSheet, @stats, @onTile, @belongsTo, @iconFile) ->

    @curhp = @stats.hp
    @weapons = []
    @weaponActive = @weapons[0] if @weapons
    @armors = []
    @moveTokens = 1
    @actionTokens = 1

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
    # speed per mili
    speed = 0.10
    p = tile.position

    # direction
    dir = 'downleft'
    console.log tile.row, tile.col
    if (tile.row < @onTile.row)
      dir = 'upright'
    else if (tile.col < @onTile.col)
      dir = 'upleft'
    else if (tile.col > @onTile.col)
      dir = 'downright'

    dist = Math.sqrt(Math.pow((p.x - @position.x), 2) + Math.pow((p.y - @position.y), 2))
    duration = dist / speed
    duration += 1 if duration == 0
    tween = @animateTo {position: p}, duration
    console.log 'dir: ', dir
    @sprite.play 'walk-'+dir
    return tween
    
  # Equip unit with an item <weapon or armor>
  equip: (item) ->
    #if item in @weapons
    #if item in @armors
    if ((item in @weapons) or (item in @armors))
      # do nothing
    else if (item instanceof Weapon)
      if not @weaponActive?
        @weaponActive = item
      @weapons.push item
    else if (item instanceof Armor)
      @armors.push item
    else
    
  # Unequip unit with an item
  unEquip: (item) ->
    #TODO: add logic for cant unEquip item that doenst exist
    if (item instanceof Weapon)
      # Remove effect
      @stats.parry -= item.parry if @parry >= item.parry # TODO: attributes parry and power do not exist
      @stats.power -= item.power if @power >= item.power
      @weapon.remove item
    else if (item instanceof Armor)
      @stats.defence -= item.defence if @stats.defence >= item.defence # TODO: bad logic (also for parry and power) - the condition check is unncessary. Plus if it turns out to be false at some point, you will unequip an armor but see no change to your defence. A better idea would be to set defence = 0 if defence < 0.
      @armors.remove item
    else
    
    
  attack: (target) ->
    console.log 'unit attack'
    damage = @stats.skill # the calculation of damage will be changed later
    target.curhp -= damage

    Common.game.battleLog @stats.name + " attacked " + target.stats.name + " to do " + damage + " damage. " + target.stats.name + "  has " + target.curhp + " HP remaining."
 
  # Use Skill on specified target
  useSkill: (skillType, target) ->
    #TODO: add Skills
    switch @type
      when "" then
      when "" then
      else

