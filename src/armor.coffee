class window.Armor extends Component
  
  # name - the name of the armor
  # cost - the cost to bring the armor into battle --> full name is initiative cost
  # defence - the defence of the armor
  # passiveAbilitesList - a list containing the passive abilities an armor has
  # icon - image icon file that represents the armor
  constructor: (@name, @cost, @defence, @passiveAbilitiesList, @icon) ->
    super()
    @addListener 'click',( ->
      console.log 'clicked item', @occupiedBy
      newEvt = {type:'selectedUnit', @occupiedBy}
      @dispatchEvent newEvt
    ).bind this

    
    
    
