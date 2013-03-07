class Weapon extends Component
  
  # name - the name of the weapon
  # cost - the cost to bring the weapon into battle --> full name is initiative cost
  # range - the attack range for the weapon
  # power - the strength of the weapon when it is used to attack
  # parry - probability (from 0 to 1) of the weapon being used to block an incoming attack
  # passiveAbilitesList - a list containing the passive abilities a weapon has
  constructor: (@name, @cost, @range, @power, @parry, @passiveAbilitiesList) ->
    