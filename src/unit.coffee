class window.Unit extends BFObject
  # charSpriteSheet - spritesheet for the unit
  # hp - total hp of the unit
  # move - number of tiles unit can move
  # evasion - probability (from 0 to 1) a incoming attack is missed
  # skill - set of skills the unit can use
  # weapon - unit's equipped set of weapons
  # armors - unit's equipped set of armors
  constructor: (@charSpriteSheet,@name,@hp,@move,@evasion,@skill) ->
    @power = 0 
    @parry = 0
    @defence = 0
    @curhp = @hp
    @weapons = []
    @armors = []
    
    super()
    @init()

  init: ->
    # TODO shouldn't instantiate units here
    sprite = new Sprite @charSpriteSheet
    sprite.addAnimation {id: 'idle', row: 0, fps: 24}
    sprite.play 'idle'
    sprite.setSize 30, 45
    @addChild sprite
    
  # Move Unit to specified x,y coordinate
  move: (x,y) ->
    
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

     
  
    
    
    
    
