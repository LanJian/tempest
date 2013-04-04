
window.Assets =
  # ----------- ARMORS -----------------
  helmet: (new Armor {
      name: "Helmet"
      cost: 1
      defence: 1
    }, null, 'img/icons/helmet.png')
    
    
  kiteShield: (new Armor {
      name: "Kite Shield"
      cost: 2
      defence: 10
    }, null, 'img/icons/kiteShield.png')


  knightPlateArmor: (new Armor {
      name: "Knight Plate Armor"
      cost: 4
      defence: 3
    }, null, 'img/icons/knightPlateArmor.png')
    
    
  knightShield: (new Armor {
      name: "Knight Shield"
      cost: 2
      defence: 10
    }, null, 'img/icons/knightShield.png')

  # ----------- WEAPONS -----------------
  crossbow: (new Weapon {
      name: "Cross Bow"
      type: 'bow'
      cost: 1
      range: 10
      power: 1
      parry: 0.02
    }, null, 'img/icons/crossbow.png')
    
    
  longbow: (new Weapon {
      name: "Long Bow"
      type: 'bow'
      cost: 2
      range: 10
      power: 1
      parry: 0.02
    }, null, 'img/icons/longBow.png')


  lightSpear: (new Weapon {
      name: "Light Spear"
      type: 'spear'
      cost: 1
      range: 2
      power: 2
      parry: 0.05
    }, null, 'img/icons/lightSpear.png')
    
    
  longSword: (new Weapon {
      name: "Long Sword"
      type: 'sword'
      cost: 1
      range: 1
      power: 2
      parry: 0.2
    }, null, 'img/icons/shortSword.png')
    
  poisonTippedSword: (new Weapon {
      name: "Poison Tipped Sword"
      type: 'sword'
      cost: 3
      range: 1
      power: 4
      parry: 0.05
    }, null, 'img/icons/poisonTippedSword.png')


  shortSword: (new Weapon {
      name: "Short Sword"
      type: 'sword'
      cost: 2
      range: 1
      power: 1
      parry: 0.05
    }, null, 'img/icons/shortSword.png')
    
    
  sword: (new Weapon {
      name: "Sword"
      type: 'sword'
      cost: 1
      range: 1
      power: 2
      parry: 0.05
    }, null, 'img/icons/sword.png')    

