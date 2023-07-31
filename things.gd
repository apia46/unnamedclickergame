extends Control
@onready var format = get_node("/root/game").format
@onready var achiev = get_node("/root/game/tabs/acheivemetns")

var things = float(0)
var thingsalltime = float(0)

var perclickamount = 1
var perclickcost = float(1)

var perclickactual = float(1)
var persecondactual = float(0)

var passivethingamount = float(0)
var passivethingcost = float(200)

var passivethingboostmultiplier = float(1)
var passivethingboostpotential = float(0.5)
var passivethingboostcost = float(10)

var passivethingmoreboostexponent = float(1)
var passivethingmoreboostpotential = float(0.1)
var passivethingmoreboostcost = float(1)

var potentialthingmultiply = float(1)
var thingmultiply = float(1)

var funnyupgradebuttonstage = 0
var funnyupgradebuttoncost = float(5000)
var timesincelastclick = float(0)
var funnyupgrade1boost = float(0)
var freethinggenerators = 0

const CYYANMECHANICCOST = float(1000000)
var cyyanmechanic = false


func processthings(delta):
	potentialthingmultiply = clampf(snapped((log(things)/5 + pow(freethinggenerators+passivethingamount+%magenter.extrathingpassive, 0.6)) / thingmultiply, 0.01), 1, INF)
	
	timesincelastclick += delta
	if funnyupgradebuttonstage >= 1:
		if timesincelastclick/(float(100)/3) > 1:
			funnyupgrade1boost = pow(timesincelastclick*60 - 2000, 0.001)
		else:
			funnyupgrade1boost = timesincelastclick*60/float(2000)
	if funnyupgradebuttonstage >= 2:
		if thingsalltime >= pow(2, freethinggenerators + 1):
			freethinggenerators += 1
			_update_passivething()
	
	perclickactual = pow(perclickamount * thingmultiply, funnyupgrade1boost + 1) * %cyyan.cyyanmultiply * (funnyupgrade1boost + 1) * (achiev.amount**(2 if %cyyan.achievsquared else 1) if funnyupgradebuttonstage >= 3 else 1)
	persecondactual = (pow((passivethingamount + freethinggenerators + %magenter.extrathingpassive), passivethingmoreboostexponent)) * thingmultiply * passivethingboostmultiplier * %cyyan.cyyanmultiply * (%cyyan.timeplayedboost if %cyyan.timeplayed else 1.0) * (achiev.amount**(2 if %cyyan.achievsquared else 1) if funnyupgradebuttonstage >= 3 else 1) + (perclickactual/2 if %cyyan.gainclick else 0.0)
	
	things += delta * persecondactual
	thingsalltime += delta * persecondactual
	
	if thingsalltime >= 1e5 and format.defaultnumberformat == format.NUMBERFORMAT.SCIENTIFIC: achiev.achs[8].unlock()

func _thingbutton():
	if perclickactual >= 10000: achiev.achs[7].unlock()
	things += perclickactual
	thingsalltime += perclickactual
	if timesincelastclick < 1200 and funnyupgradebuttonstage >= 1: achiev.achs[4].unlock()
	timesincelastclick = 0
	achiev.achs[0].unlock()

func _perclickbuy():
	perclickamount += 1
	things -= perclickcost
	perclickcost *= perclickamount
	_update_perclickbuy()

func _passivethingbuy():
	if !%cyyan.passivenocost: 
		if things < passivethingcost: return
		things -= passivethingcost
	passivethingamount += 1
	passivethingcost = 200 * pow(1.1, passivethingamount)
	_update_passivething()
	if passivethingamount >= 69: achiev.achs[9].unlock()

func _passivethingboost():
	# prioritise spending free generators 
	var bonusgeneratorsspent = clamp(round(passivethingboostcost), 0, floor(%magenter.extrathingpassive))
	
	%magenter.extrathingpassive -= bonusgeneratorsspent
	passivethingamount = clamp((passivethingamount - round(passivethingboostcost) + bonusgeneratorsspent), 0, INF)
	
	passivethingboostmultiplier += passivethingboostpotential
	passivethingcost = 200 * pow(1.1, passivethingamount)
	passivethingboostcost = pow(passivethingboostcost, 1.15)
	_update_passivethingboost()

func _passivethingmoreboost():
	passivethingmoreboostexponent += passivethingmoreboostpotential
	passivethingboostmultiplier -= passivethingmoreboostcost
	passivethingboostcost = 10
	if !(passivethingboostmultiplier <= 1): for i in range(passivethingboostmultiplier * 2 - 1):
		passivethingboostcost = pow(passivethingboostcost, 1.15)
	passivethingmoreboostcost *= 2
	_update_passivethingmoreboost()
	achiev.achs[1].unlock()

func _themorethingsbutton():
	if potentialthingmultiply < 1.5: achiev.achs[2].unlock()
	thingmultiply *= potentialthingmultiply
	passivethingamount = 0
	%magenter.extrathingpassive = 0
	passivethingcost = 200
	things = 0
	_update_passivething()

func _funnyupgradebutton():
	things -= funnyupgradebuttoncost
	funnyupgradebuttonstage += 1
	_update_funny_upgrade_stages()

func _cyyanmechanic():
	cyyanmechanic = true
	things -= CYYANMECHANICCOST
	achiev.achs[10].unlock()
	_update_cyyanmechanic()


func _update_all():
	_update_per_frame()
	_update_perclickbuy()
	_update_passivething()
	_update_passivethingboost()
	_update_passivethingmoreboost()
	_update_funny_upgrade_stages()
	_update_cyyanmechanic()

func _update_per_frame():
	%thingcount.text = ("You have " + format.number(things) + " things.")
	%information.text = ("You get " + format.number(perclickactual) + " things per click\nand " + format.number(persecondactual) + " things every second")
	
	%themorethingsbutton.disabled = (potentialthingmultiply <= 1)
	%themorethingsbutton.text = ("sacrifice all your things\nand thing generators but\nyou get " + format.number(potentialthingmultiply) + "x more\nthings per thing (x" + format.number(thingmultiply) + ")")
	
	%perclickbuy.disabled = !(things >= perclickcost)
	%passivethingbuy.disabled = !(things >= floor(passivethingcost))
	%funnyupgradebutton.disabled = !(things >= funnyupgradebuttoncost) or funnyupgradebuttoncost == -1
	
	%cyyanmechanic.disabled = !(things >= CYYANMECHANICCOST) or cyyanmechanic
	%cyyanmechanic.visible = thingsalltime > CYYANMECHANICCOST
	if !cyyanmechanic:
		if things >= CYYANMECHANICCOST:
			%cyyanmechanic.text = ("CYYAN THINGS\nthis costs " + format.number(CYYANMECHANICCOST) + " things")
		else:
			%cyyanmechanic.text = ("??? this costs " + format.number(CYYANMECHANICCOST) + " things")
	
	%passivethingbuy.text = ("passive thing generation (" + format.number(passivethingamount) + ((" + " + format.number(freethinggenerators)) if (freethinggenerators > 0) else "") + (("\n+ " + format.number(%magenter.extrathingpassive, 0)) if %cyyan.magentermechanic else "") + ")\nthis " + ("requires " if %cyyan.passivenocost else "costs ") + format.number(passivethingcost) + " things")

func _update_perclickbuy():
	%perclickbuy.text = ("more things per click (" + format.number(perclickamount) + ")\nthis costs " + format.number(perclickcost) + " things")

func _update_passivething():
	%passivethingboost.disabled = !((passivethingamount + freethinggenerators+%magenter.extrathingpassive) >= round(passivethingboostcost))
	%passivethingbuy.disabled = !(things >= floor(passivethingcost))

func _update_passivethingboost():
	%passivethingboost.text = ("x" + format.number(passivethingboostpotential + passivethingboostmultiplier) + " passive thing generation (x" + format.number(passivethingboostmultiplier) + ")\nthis costs " + format.number(passivethingboostcost, 0) + " passive thing generators")
	%passivethingmoreboost.disabled = !(passivethingboostmultiplier >= passivethingmoreboostcost + 1)
	_update_passivething()

func _update_passivethingmoreboost():
	%passivethingmoreboost.text = ("makes passive thing generation ^" + format.number(passivethingmoreboostexponent + passivethingmoreboostpotential) + "\ncosts " + format.number(passivethingmoreboostcost, 0) + "x passive generation boost (^" + format.number(passivethingmoreboostexponent) + ")")
	%passivethingmoreboost.disabled = !(passivethingboostmultiplier >= passivethingmoreboostcost + 1)
	_update_passivethingboost()

func _update_funny_upgrade_stages():
	var upgrade = ""
	match int(funnyupgradebuttonstage):
		0:
			funnyupgradebuttoncost = 5000
			upgrade = "things per click increases exponentially\nwith time since last click"
		1:
			funnyupgradebuttoncost = 20000
			upgrade = "every 2x things you get\ngrants you a free thing generator"
			achiev.achs[3].unlock()
		2:
			funnyupgradebuttoncost = 80000
			upgrade = "you get a multiplier on things\nbased on achievements"
			achiev.achs[5].unlock()
		_:
			funnyupgradebuttoncost = -1
			upgrade = "youve bought all of them"
			achiev.achs[14].unlock()
	%funnyupgradebutton.text = ("funny upgrade button (stage " + format.number(funnyupgradebuttonstage, 0) + ")\n" + upgrade + (("\nthis costs " + format.number(funnyupgradebuttoncost) + " things") if funnyupgradebuttoncost != -1 else ""))

func _update_cyyanmechanic():
	if cyyanmechanic:
		%cyyanmechanic.text = "CYYAN THINGS\nUNLOCKED"
		%things.set_tab_disabled(1, false)
		%things.set_tab_title(1, "cyyan")
	else:
		%things.set_tab_disabled(1, true)
		%things.set_tab_title(1, "???")


func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"things" : things,
		"thingsalltime" : thingsalltime,
		"perclickamount" : perclickamount,
		"perclickcost" : perclickcost,
		"perclickactual" : perclickactual,
		"persecondactual" : persecondactual,
		"passivethingamount" : passivethingamount,
		"passivethingcost" : passivethingcost,
		"passivethingboostmultiplier" : passivethingboostmultiplier,
		"passivethingboostpotential" : passivethingboostpotential,
		"passivethingboostcost" : passivethingboostcost,
		"passivethingmoreboostexponent" : passivethingmoreboostexponent,
		"passivethingmoreboostpotential" : passivethingmoreboostpotential,
		"passivethingmoreboostcost" : passivethingmoreboostcost,
		"potentialthingmultiply" : potentialthingmultiply,
		"thingmultiply" : thingmultiply,
		"funnyupgradebuttonstage" : funnyupgradebuttonstage,
		#"funnyupgradebuttoncost" : funnyupgradebuttoncost,
		"timesincelastclick" : timesincelastclick,
		"funnyupgrade1boost" : funnyupgrade1boost,
		"freethinggenerators" : freethinggenerators,
		"cyyanmechanic" : cyyanmechanic,
	}
	return save_dict
