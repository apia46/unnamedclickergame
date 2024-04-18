extends HFlowContainer
var funnyUpgButton = preload("res://game/things/funnyUpgButton.tscn")
@onready var things = $"../../../../.."

const maxUpgs = 7

var stage = 1
var upg5Triggered = false
var upg7Triggered = false
# computed
var upgButtons = []

func _ready(): pass

# functions here

# processes here

func _funnyUpg_buy():
	if stage < maxUpgs:
		upgButtons.append(funnyUpgButton.instantiate().set_data(stage))
		var button = upgButtons[stage]
		add_child(button)
	stage += 1
	updateUpgs()

func updateUpgs():
	if !upg5Triggered and stage > 5:
		things.addThings(20001)
		upg5Triggered = true
	if !upg7Triggered and stage > 7:
		things.addThings(59999)
		upg7Triggered = true

func update():
	upgButtons = []
	for i in range(min(stage, maxUpgs)):
		upgButtons.append(funnyUpgButton.instantiate().set_data(i, i<stage-1))
		var button = upgButtons[i]
		add_child(button)
	updateUpgs()

func updateButtons():
	for button in upgButtons: button.updateButtons()

func updateText():
	for button in upgButtons: button.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"stage" : stage,
		"upg5Triggered" : upg5Triggered,
		"upg7Triggered" : upg7Triggered,
	}
