class window.Unit extends BFObject
  # charSpriteSheet - spritesheet for the unit
  # hp - total hp of the unit
  # moveRange - number of tiles unit can move
  # evasion - probability (from 0 to 1) a incoming attack is missed
  # skill - stat that determines the unit's evasion and attack
  # weapon - unit's equipped weapon
  # armors - unit's equipped set of armors
  constructor: (@charSpriteSheet, @stats, @onTile, @belongsTo, @iconFile, @row, @col, @enemy) ->

    @curhp = @stats.hp
    @weapons = []
    @weaponActive = @weapons[0] if @weapons
    @lastDir = 'upright'    
    if @enemy
      @lastDir = 'downleft'
    @armors = []
    @moveTokens = 1
    @actionTokens = 1
    @cfg = [1,7,7,5]

    @sprite = new Sprite @charSpriteSheet
    super @sprite, 1, 1
  init: ->
    super()
    
    @sprite.addAnimation {id: 'idle-downleft', row: 0, fps: @cfg[0]}
    @sprite.addAnimation {id: 'idle-upright', row: 1, fps: @cfg[0]}
    @sprite.addAnimation {id: 'idle-downright', row: 2, fps: @cfg[0]}
    @sprite.addAnimation {id: 'idle-upleft', row: 3, fps: @cfg[0]}


    @sprite.addAnimation {id: 'walk-downleft', row: 4, fps: @cfg[1]}
    @sprite.addAnimation {id: 'walk-upright', row: 5, fps: @cfg[1]}
    @sprite.addAnimation {id: 'walk-downright', row: 6, fps: @cfg[1]}
    @sprite.addAnimation {id: 'walk-upleft', row: 7, fps: @cfg[1]}
    
    @sprite.addAnimation {id: 'attack-downleft', row: 8, fps: @cfg[2]}
    @sprite.addAnimation {id: 'attack-upright', row: 9, fps: @cfg[2]}
    @sprite.addAnimation {id: 'attack-downright', row: 10, fps: @cfg[2]}
    @sprite.addAnimation {id: 'attack-upleft', row: 11, fps: @cfg[2]}
    
    @sprite.addAnimation {id: 'hit-downleft', row: 12, fps: @cfg[3]}
    @sprite.addAnimation {id: 'hit-upright', row: 13, fps: @cfg[3]}
    @sprite.addAnimation {id: 'hit-downright', row: 14, fps: @cfg[3]}
    @sprite.addAnimation {id: 'hit-upleft', row: 15, fps: @cfg[3]}
    
    @sprite.play 'idle-' + @lastDir

    @addListener 'spriteStopAnim', ((evt)->
      #console.log 'stop animation'
      #console.log evt.origin
      if evt.origin is @sprite
          #console.log 'stop', 'idle-'+@lastDir
          @sprite.play 'idle-'+ @lastDir 
    ).bind this
    
  # Move Unit to specified tile
  moveTo: (tile) ->
    #console.log 'Size', @size
    #check if destination is occupied
    #if not (Common.battleField.inRange @onTile, tile, @stats.moveRange) or (tile.occupiedBy != null)
      #return false
    # speed per mili
    speed = 0.10
    p = tile.position
    #console.log 'Tile position', tile.position.y, @size.h, @baseTiles
    p = {x:tile.position.x , y: (tile.position.y - (@size.h - Common.battleField.tileHeight))}
    dist = Math.sqrt(Math.pow((p.x - @position.x), 2) + Math.pow((p.y - @position.y), 2))
    #console.log 'target', p
    duration = dist / speed
    duration += 1 if duration == 0
    tween = @animateTo {position: p}, duration
    dir = @getDir @onTile, tile
    @sprite.play 'walk-'+ @lastDir
    return tween
 
  changeDir: (dir) ->
    @lastDir = dir
    @sprite.play 'idle-'+@lastDir
    
  getOppDir: (dir) ->
    switch dir
      when "downleft"
        return "upright"
      when "upright" 
        return "downleft"
      when "downright"
        return "upleft"
      when "upleft"
        return "downright"
   
  getDir: (origin, target) ->
    # direction
    rowDiff = target.row - origin.row
    colDiff = target.col - origin.col
    dir = ''
    #console.log 'row diff', rowDiff, colDiff
    if (Math.abs rowDiff) >= (Math.abs colDiff)
      dir = 'downleft'
      if (target.row < origin.row)
        dir = 'upright'
    else
      dir = 'upleft'
      if (target.col > origin.col)
        dir = 'downright'
    @lastDir = dir
    return dir
   
  # Equip unit with an item <weapon or armor>
  equip: (item) ->
    #if item in @weapons
    #if item in @armors
    if ((item in @weapons) or (item in @armors))
      #console.log 'Equip an item already equipped'
    else if (item instanceof Weapon)
      if not @weaponActive?
        @weaponActive = item
      @weapons.push item
    else if (item instanceof Armor)
      @armors.push item
    else
      #console.log 'Can not equip unknown item type'
    
  # Unequip unit with an item
  unEquip: (item) ->
    #TODO: add logic for cant unEquip item that doenst exist
    if (item instanceof Weapon)
      @weapon.remove item
    else if (item instanceof Armor)
      @armors.remove item
    else
      #console.log 'Can not unequip unknown item type'


  canAttack: (target) ->
    return ((@onTile.distanceTo target.onTile) <= @weaponActive.stats.range)
    
    
  attack: (target) ->

    #console.log 'spritesheet', @sprite
    #console.log 'unit attack'
    dir = @getDir @onTile, target.onTile
    @sprite.playOnce 'attack-' + dir
    #console.log '()()()()() weapon type', @weaponActive.stats.type
    
    target.changeDir (@getOppDir dir)
    
    switch @weaponActive.stats.type
      when "sword" , "spear"
        @doDamage target
      when "bow"
        # TODO: don't load this here, assets should be loaded in the beginning
        bowSpriteSheet = new SpriteSheet 'img/arrow.png', [
          {length: 1, cellWidth: 64, cellHeight: 64},
          {length: 1, cellWidth: 64, cellHeight: 64},
          {length: 1, cellWidth: 64, cellHeight: 64},
          {length: 1, cellWidth: 64, cellHeight: 64}
        ]
        bowSprite = new Sprite bowSpriteSheet
        bowSprite.addAnimation {id: 'shoot-downleft', row: 0, fps: 1}
        bowSprite.addAnimation {id: 'shoot-upright', row: 1, fps: 1}
        bowSprite.addAnimation {id: 'shoot-downright', row: 2, fps: 1}
        bowSprite.addAnimation {id: 'shoot-upleft', row: 3, fps: 1}
        bowSprite.setPosition @onTile.position.x, @onTile.position.y
      
        tile = target.onTile
        Common.battleField.addChild bowSprite
        #Common.battleField.addObject bowSprite, @onTile.row, @onTile.col
        speed = 0.20
        p = tile.position
        dist = Math.sqrt(Math.pow((p.x - @position.x), 2) + Math.pow((p.y - @position.y), 2))
        duration = dist / speed
        duration += 1 if duration == 0
        tween = bowSprite.animateTo {position: p}, duration
        bowSprite.play 'shoot-'+dir
        #console.log 'bow', dir
        tween.onComplete ( ->
          Common.battleField.removeChild bowSprite
          @doDamage target
        ).bind this
    

  doDamage: (target) ->
    console.log 'doDmg'
    # Check evasion
    if Math.random() > target.stats.evasion * 0.5
      rand = Math.random()
      #console.log 'rand for parry', rand
      #console.log 'crazy math', (target.getWeaponParry() + target.stats.skill*0.05)
      if (not target.weaponActive) or (rand > target.getWeaponParry() + target.stats.skill*0.05)
        # Attacker's weapon power + attacker's skill - defender's armors
        # Calculate defender's amors
        armor = 0
        for a in target.armors
          armor += a.stats.defence
        damage = @weaponActive.stats.power + @stats.skill - armor  # the calculation of damage will be changed later
        
        damage = 0 if damage < 0
        if damage >= target.curhp
          target.curhp = 0
        else
          target.curhp -= damage
        Common.audios.hurt.play()
        log = @stats.name + " attacked " + target.stats.name + " to do " + damage + " damage. " + target.stats.name + "  has " + target.curhp + " HP remaining."
        # Attack Animation
        #console.log 'Target lastdir', @lastDir
        target.sprite.playOnce 'hit-'+ target.lastDir
      else
        target.sprite.playOnce 'attack-'+ target.lastDir
        log = 'Attack got parried'
    else
      target.sprite.playOnce 'walk-'+ target.lastDir
      log = 'Attack got evasiond'

    if target.curhp <= 0
        Common.battleField.removeUnit target
        
    if ((Common.state.turn != @enemy) and (Common.enemy.units.length == 0))
        Common.state.endTurn()
        
    Common.game.battleLog log
   # Common.actionComplete = true

  # Returns the parry of the current active weapon
  getWeaponParry: ->
    if @weaponActive?
      return @weaponActive.getParry()
    else
      return 0
    
  # Returns the range of the current active weapon  
  getWeaponRange: ->
    if @weaponActive?
      return @weaponActive.getRange()
    else
      return 0
      
  # Use Skill on specified target
  useSkill: (skillType, target) ->
    #TODO: add Skills
    switch @type
      when "" then
      when "" then
      else

