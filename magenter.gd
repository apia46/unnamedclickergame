extends Control
@onready var format = get_node("/root/game").format

var magenterthings = float(0)
var magenterthingsalltime = float(0)
var thingpassivepersecond = float(0)
var extrathingpassive = float(0)
var magenteryield = float(0.01)
var magenterperclick = float(0)
var magenterperclickactual = float(0)
const CYYANPERMAGENTER = float(1e10)
var thingspercyyancost = float(1)
var multiplier

func processmagenter(delta):
	if !%cyyan.magentermechanic: return
	magenterperclick = %cyyan.cyyanthings/CYYANPERMAGENTER
	thingpassivepersecond = pow(magenterthings/10, 0.5)
	extrathingpassive += thingpassivepersecond*delta
	magenterperclickactual = ((magenterperclick)**(%normal.funnyupgrade1boost))*magenteryield
	%normal._update_passivething()

func _magenterbutton():
	magenterthings += magenterperclickactual
	magenterthingsalltime += magenterperclickactual
	%normal.timesincelastclick = 0
	_update_magenterthings()

func _thingspercyyan():
	magenterthings -= thingspercyyancost
	thingspercyyancost *= 2
	%cyyan.thingspercyyan *= multiplier
	_update_magenterthings()
	_update_thingspercyyan()


func _update_all():
	_update_magenterthings()
	_update_thingspercyyan()

func _update_per_frame():
	%magenterthings3.text = "giving you " + format.number(extrathingpassive, 0) + " extra thing generators total"
	%magenterbutton.text = "Sacrifice your time since last click (" + format.time(%normal.timesincelastclick, format.TIMEMODE.SINGLE) + ")\nat " + format.number(magenteryield*100) + "% yield\nfor " + format.number(magenterperclickactual) + " magenter things"

func _update_magenterthings():
	processmagenter(0)
	%magenterthings.text = "you have " + format.number(magenterthings) + " magenter things,"
	%magenterthings2.text = "giving you " + format.number(thingpassivepersecond) + " thing generators per second,"
	
	%thingspercyyan.disabled = !(magenterthings >= thingspercyyancost)

func _update_thingspercyyan():
	multiplier = 1+(-0.2/log((thingspercyyancost)**0.2+10))
	%thingspercyyan.text = "decrease things per cyyan\n" + format.number(%cyyan.thingspercyyan) + " -> " + format.number(%cyyan.thingspercyyan*multiplier) + "\nthis costs " + format.number(thingspercyyancost) + "\nmagenter things"


func save():
	var save_dict = {
		"nodepath" = self.get_path(),
		"magenterthings" = magenterthings,
		"magenterthingsalltime" = magenterthingsalltime,
		"extrathingpassive" = extrathingpassive,
		"thingspercyyancost" = thingspercyyancost,
	}
	return save_dict
