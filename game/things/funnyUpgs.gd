extends HFlowContainer
const FUNNYUPGBUTTON = preload("res://game/things/funnyUpgButton.tscn")
@onready var things = $"../../../../../.."
@onready var game = $"/root/game"

var stage = 1
var upg5Triggered = false
var upg7Triggered = false
var maxUpgs = 10
var bored = 0
# computed
var upgButtons = []

func _ready(): pass

# functions here

# processes here

func _funnyUpg_buy():
	if stage < maxUpgs:
		upgButtons.append(FUNNYUPGBUTTON.instantiate().set_data(stage))
		var button = upgButtons[stage]
		add_child(button)
	stage += 1
	updateUpgs()

func updateUpgs():
	if stage > 1: game.achievements.unlockAch("basic",1)
	if stage > 3: game.achievements.unlockAch("basic",2)
	if stage > 5: game.achievements.unlockAch("basic",3)
	if stage > 7: game.achievements.unlockAch("basic",4)
	if stage > 9: game.achievements.unlockAch("basic",5)
	if stage > 10: game.achievements.unlockAch("cyyan",0)
	if stage > 11: game.achievements.unlockAch("cyyan",1)
	if stage > 13: game.achievements.unlockAch("cyyan",2)
	if !upg5Triggered and stage > 5:
		things.addThings(Dec.D(20001))
		upg5Triggered = true
	if !upg7Triggered and stage > 7:
		things.addThings(Dec.D(59999))
		upg7Triggered = true
	if !game.cyyanUnlocked and stage > 10:
		game.updateTabs(game.UNLOCK.CYYAN)

func update():
	for button in upgButtons: button.queue_free()
	upgButtons = []
	for i in range(min(stage, maxUpgs)):
		upgButtons.append(FUNNYUPGBUTTON.instantiate().set_data(i, i<stage-1))
		var button = upgButtons[i]
		add_child(button)
	updateUpgs()

func updateButtons():
	for button in upgButtons: button.updateButtons()

func updateText():
	for button in upgButtons: button.updateText()

func save():
	return {
		"node" : self.name,
		"nodepath" : self.get_path(),
		"stage" : stage,
		"upg5Triggered" : upg5Triggered,
		"upg7Triggered" : upg7Triggered,
		"maxUpgs" : maxUpgs,
		"bored" : bored,
	}
