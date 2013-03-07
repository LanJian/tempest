class Armor extends Component
  
  # name - the name of the armor
  # cost - the cost to bring the armor into battle --> full name is initiative cost
  # defence - the defence of the armor
  # passiveAbilitesList - a list containing the passive abilities an armor has
  constructor: (@name, @cost, @defence, @passiveAbilitiesList) ->
    