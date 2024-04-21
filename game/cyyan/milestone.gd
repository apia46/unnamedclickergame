extends Button
@onready var parent = get_parent()

var id : int
var active = false
# computed
@onready var requirement = Dec.D(0)
var effect = ""

func _ready(): pass # likely just pass

func set_data(Id,Active:=false):
	id = Id
	active = Active
	return self

# processes here

# _listeners here

func updateButtons():
	match id:
		0: requirement = Dec.D(1)
		1: requirement = Dec.D(10)
		2: requirement = Dec.D(50)
		3: requirement = Dec.D(500)
		_: requirement = Dec.D(0)
	
	if !active and parent.cyyan.cyyan.GE(requirement):
		active = true
		parent.unlockMilestone()
	disabled = !active

func updateText():
	match id:
		0: effect = "TPS multiplier\nbased on cyyan things\nCurrently x"+parent.game.things.milestone1.F()
		1: effect = "Unlocks 5 more funny upgrades"
		2: effect = "Funny upgrade 2 effect ^1.5"
		3: effect = "Win condition (for now )"
		_: effect = "Error: you have too many milestones somehow"
	text = "Milestone "+str(id+1)+"
(requires "+requirement.F("total cyyan thing",true)+")
"+(effect if active else "???")

func save():
	return {
		"nodepath" : self.get_path(),
	}

