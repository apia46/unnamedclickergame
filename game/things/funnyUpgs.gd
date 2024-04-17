extends HFlowContainer
var funnyUpgButton = preload("res://game/things/funnyUpgButton.tscn")
@onready var things = $"../../../../.."

var upgButtons = []
var upg = 1
# computed
@onready var computed # computed vars

func _ready(): pass

# functions here

# processes here

func _funnyUpg_buy():
	upgButtons.append(funnyUpgButton.instantiate().set_data(upg))
	var button = upgButtons[upg]
	add_child(button)
	upg += 1
	updateFunnyUpgEffects()

func updateFunnyUpgEffects():
	if upg > 1:
		things.generators.mulGensPer(2)

func update():
	upgButtons = []
	for i in range(upg):
		upgButtons.append(funnyUpgButton.instantiate().set_data(i, i<upg-1))
		var button = upgButtons[i]
		add_child(button)
	updateFunnyUpgEffects()

func updateButtons():
	for button in upgButtons: button.updateButtons()

func updateText():
	for button in upgButtons: button.updateText()
