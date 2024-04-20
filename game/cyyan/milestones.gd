extends HBoxContainer
const MILESTONE = preload("res://game/cyyan/milestone.tscn")
@onready var game = $"/root/game"
@onready var cyyan = $"../../../../.."

const MAXMILESTONES = 4

var stage = 1
# computed
var milestoneButtons = []

func _ready(): pass # likely just pass

# functions here

# processes here

# _listeners here

func unlockMilestone():
	if stage < MAXMILESTONES:
		milestoneButtons.append(MILESTONE.instantiate().set_data(stage))
		var button = milestoneButtons[stage]
		add_child(button)
	stage += 1
	updateMilestones()

func updateMilestones():
	if stage > 2: game.things.funnyUpgs.maxUpgs = 15; game.things.funnyUpgs.update()

func update():
	for button in milestoneButtons: remove_child(button)
	milestoneButtons = []
	for i in range(min(stage, MAXMILESTONES)):
		milestoneButtons.append(MILESTONE.instantiate().set_data(i, i<stage-1))
		var button = milestoneButtons[i]
		add_child(button)
	updateMilestones()

func updateButtons():
	for button in milestoneButtons: button.updateButtons()

func updateText():
	for button in milestoneButtons: button.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"stage" : self.stage,
	}

