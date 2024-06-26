extends HBoxContainer
const MILESTONE = preload("res://game/cyyan/milestone.tscn")
@onready var game = $"/root/game"
@onready var cyyan = $"../../../../.."

const MAXMILESTONES = 10

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
	if stage > 3: game.achievements.unlockAch("cyyan",3)
	if stage > 4: game.achievements.unlockAch("cyyan",4)
	if stage > 8: game.achievements.unlockAch("cyyan",7)
	if stage > 10: game.achievements.unlockAch("magenter",0)

func update():
	for button in milestoneButtons: button.queue_free()
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
		"node" : self.name,
		"stage" : self.stage,
	}
