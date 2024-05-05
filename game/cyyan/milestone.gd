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
	if id == 4: theme = load("res://assets/themes/cyyantheme.tres")
	if id == 9: theme = load("res://assets/themes/unclickablemagenter.tres")
	return self

# processes here

func _clicked():
	parent.game.things.clicks._clicked()

func updateButtons():
	match id:
		0: requirement = Dec.D(1)
		1: requirement = Dec.D(5)
		2: requirement = Dec.D(50)
		3: requirement = Dec.D(1000)
		4: requirement = Dec.D(1e4)
		5: requirement = Dec.D(1e5)
		6: requirement = Dec.D(1e6)
		7: requirement = Dec.D(1e8)
		8: requirement = Dec.D(1e10)
		9: requirement = Dec.D(1e14)
		_: requirement = Dec.D(0)
	
	if !active and parent.cyyan.cyyan.GE(requirement):
		active = true
		parent.unlockMilestone()
	disabled = !active

func updateText():
	match id:
		0: effect = "Generator output multiplier\nbased on cyyan things\nCurrently x"+parent.game.things.milestone1.F()
		1: effect = "Unlocks 5 more funny upgrades"
		2: effect = "Funny upgrade 2 effect ^"+parent.game.things.clicks.milestone3.F("",true)
		3: effect = "Unlock cyyan choices"
		4: effect = "Button to press\nto test upgrades with\nActs as the thing button"
		5: effect = "Funny upgrade 11 effect x2"
		6: effect = "Generator price\nscales slower\n1.2^n -> 1.1^n"
		7: effect = "an achievement, i guess\nyou can do it!"
		8: effect = "TPS multiplier\nbased on milestone 1\nCurrently x"+parent.game.things.milestone9.F()
		9: effect = "win condition, for now"
		_: effect = "Error: you have too many milestones somehow"
	text = "Milestone "+str(id+1)+"
(requires "+requirement.F("cyyan thing",true)+")
"+(effect if active else "???")

func save():
	return {
		"nodepath" : self.get_path(),
	}
