extends Control
@onready var format = get_node("/root/game").format

var magenterthings = float(0)
var thingpassivepersecond = float(0)
var extrathingpassive = float(0)
var magenteryield = float(0.01)
var magenterperclick = float(0)


func processmagenter(_delta):
	if !%cyyan.magentermechanic: return
	thingpassivepersecond = pow(magenterthings/10, 0.5)


func _update_all():
	_update_magenterthings()

func _update_per_frame():
	%magenterthings3.text = "giving you " + format.number(extrathingpassive) + " extra thing generators total"
	%magenterbutton.text = "Sacrifice your time since last click (" + format.time(%normal.timesincelastclick, format.TIMEMODE.SINGLE) + ")\nat " + format.number(magenteryield*100) + "% yield\nfor " + format.number(magenterperclick) + " magenter things"

func _update_magenterthings():
	%magenterthings.text = "you have " + format.number(magenterthings) + " magenter things,"
	%magenterthings2.text = "giving you " + format.number(thingpassivepersecond) + " thing generators per second,"
#" + format.number() + "

func _save():
	var save_dict = {
		"nodepath" = self.get_path(),
	}
	return save_dict
