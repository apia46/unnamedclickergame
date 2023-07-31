extends Control
@onready var format = get_node("/root/game").format
@onready var game = get_node("/root/game")
@onready var achiev = get_node("/root/game/tabs/acheivemetns")

func _ready():
	pass

var thingspercyyan = float(1000000)
var cyyanthings = float(0)
var cyyanthingscosted = float(0)
var cyyanmultiply = float(1)

const PASSIVENOCOSTCOST = float(100)
var passivenocost = false

const GAINCLICKCOST = float(1e3)
var gainclick = false

const AUTOMATEDPASSIVECOST = float(1e4)
var automatedpassive = false

const TIMEPLAYEDCOST = float(1e7)
var timeplayed = false
var timeplayedboost = float(1)

const ACHIEVSQUAREDCOST = float(1e9)
var achievsquared = false

const MAGENTERMECHANICCOST = float(1e12)
var magentermechanic = false


func processcyyan(_delta):
	if !%normal.cyyanmechanic: return
	cyyanthings = floor(%normal.thingsalltime / thingspercyyan) - cyyanthingscosted
	if pow(cyyanthings, 0.7) + 1 < 1e6:
		cyyanmultiply = pow(cyyanthings, 0.7) + 1
	else:
		cyyanmultiply = pow(log(cyyanthings-4e8), 5.1)/3 + 1e6
	@warning_ignore("integer_division")
	timeplayedboost = clampf(game.time/500, 1, 500)

func _passivenocost():
	cyyanthingscosted += PASSIVENOCOSTCOST
	passivenocost = true
	%passivenocost.text = "passive thing generators no\nlonger costs things"
	_update_passivenocost()
	achiev.achs[15].unlock()

func _gainclick():
	cyyanthingscosted += GAINCLICKCOST
	gainclick = true
	_update_gainclick()

func _automatedpassive():
	cyyanthingscosted += AUTOMATEDPASSIVECOST
	automatedpassive = true
	_update_automatedpassive()

func _timeplayed():
	cyyanthingscosted += TIMEPLAYEDCOST
	timeplayed = true

func _achievsquared():
	cyyanthingscosted += ACHIEVSQUAREDCOST
	achievsquared = true
	achiev._update_ach()
	_update_achievsquared()
	achiev.achs[16].unlock()

func _magentermechanic():
	_update_achievsquared()
	magentermechanic = true
	cyyanthingscosted += MAGENTERMECHANICCOST
	_update_magentermechanic()
	achiev.achs[17].unlock()


func _update_all():
	_update_per_frame()
	_update_passivenocost()
	_update_gainclick()
	_update_automatedpassive()
	_update_achievsquared()
	_update_magentermechanic()

func _update_per_frame():
	%cyyanthings.text = ("you have " + format.number(cyyanthings) + " cyyan things,\ngiving you x" + format.number(cyyanmultiply) + " thing generation")
	%passivenocost.disabled = !((cyyanthings) >= PASSIVENOCOSTCOST) or passivenocost
	
	%gainclick.disabled = !((cyyanthings) >= GAINCLICKCOST) or gainclick
	
	%automatedpassive.disabled = !((cyyanthings) >= AUTOMATEDPASSIVECOST) or automatedpassive
	
	%timeplayed.disabled = !((cyyanthings) >= TIMEPLAYEDCOST) or timeplayed
	%timeplayed.text = "you get a multiplier on thing\ngeneration based on time played\n( " + ("capped at " if timeplayedboost == 500 else "") + "x" + format.number(timeplayedboost) + " )\n" + (("this costs " + format.number(TIMEPLAYEDCOST) + " cyyan things") if !timeplayed else "")
	
	%cyyaninfo.text = "you get 1 cyyan thing every " + format.number(thingspercyyan) + " things you get\nthis menas you get " + format.number(%normal.persecondactual/thingspercyyan) + " cyyan things per second\ncyyan things give you a multiplier to your thing production"
	
	%achievsquared.disabled = !((cyyanthings) >= ACHIEVSQUAREDCOST) or achievsquared
	
	%magentermechanic.disabled = !(cyyanthings >= MAGENTERMECHANICCOST) or magentermechanic
	%magentermechanic.visible = cyyanthings+cyyanthingscosted > MAGENTERMECHANICCOST
	if !magentermechanic:
		if cyyanthings >= MAGENTERMECHANICCOST*0.5:
			%magentermechanic.text = ("MAGENTER THINGS\nthis costs " + format.number(MAGENTERMECHANICCOST) + " cyyan things")
		else:
			%magentermechanic.text = ("???\nthis costs " + format.number(MAGENTERMECHANICCOST) + " cyyan things")

func _update_passivenocost():
	%passivenocost.text = "passive thing generators no\nlonger costs things" + (("\nthis costs " + format.number(PASSIVENOCOSTCOST) + " cyyan things") if !passivenocost else "")

func _update_gainclick():
	%gainclick.text = "you get 50% of your things\nper click per second" + (("\nthis costs " + format.number(GAINCLICKCOST) + " cyyan things") if !gainclick else ("\n( +" + format.number(%normal.perclickactual/2) + " )"))

func _update_automatedpassive():
	%automatedpassive.text = "passive thing generators are\nautomatically bought\nevery " + format.number(game.automatortick) + " seconds" + ("\nthis costs " + format.number(AUTOMATEDPASSIVECOST) + " cyyan things" if !automatedpassive else "")

func _update_achievsquared():
	%achievsquared.text = "the achievement multiplier\nis now squared" + (("\nthis costs " + format.number(ACHIEVSQUAREDCOST) + " cyyan things") if !achievsquared else "")

func _update_magentermechanic():
	if magentermechanic:
		%magentermechanic.text = "MAGENTER THINGS\nUNLOCKED"
		%things.set_tab_disabled(2, false)
		%things.set_tab_title(2, "magenter")
	else:
		%things.set_tab_disabled(2, true)
		%things.set_tab_title(2, "???")


func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"thingspercyyan" : thingspercyyan,
		"cyyanthings" : cyyanthings,
		"cyyanthingscosted" : cyyanthingscosted,
		#"cyyanmultiply" : cyyanmultiply,
		"passivenocost" : passivenocost,
		"gainclick" : gainclick,
		"automatedpassive" : automatedpassive,
		"timeplayed" : timeplayed,
		#"timeplayedboost" : timeplayedboost,
		"achievsquared" : achievsquared,
		"magentermechanic" : magentermechanic,
	}
	return save_dict
