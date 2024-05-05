extends VBoxContainer
@onready var game = $"/root/game"
@onready var cyyan = $"../../../../.."

# i am most certainly doing this wrong

var active1 = false
var passive1 = false
var active2 = false
var timing2 = false
var passive2 = false
var active3 = false
var passive3 = false
var active4 = false
var timing4 = false
var passive4 = false

# computed
@onready var cost1 = Dec.D(1e3)
@onready var cost2 = Dec.D(2e4)
@onready var cost3 = Dec.D(3e5)
@onready var cost4 = Dec.D(4e6)


func _ready(): pass # likely just pass

# functions here

# processes here

# _listeners here

func update():
	updateChoices()

func updateChoices():
	cost1 = Dec.D(1e3).Mul(20**[active1, passive1].count(true))
	cost2 = Dec.D(2e4).Mul(20**[active2, timing2, passive2].count(true))
	cost3 = Dec.D(3e5).Mul(20**[active3, passive3].count(true))
	cost4 = Dec.D(4e6).Mul(20**[active4, timing4, passive4].count(true))
	if active1 and passive1 and active2 and timing2 and passive2 and active3 and passive3 and active4 and timing4 and passive4: game.achievements.unlockAch("cyyan", 8)

func updateButtons():
	$"level1/active".disabled = !cyyan.cyyan.GE(cost1) or active1
	$"level1/passive".disabled = !cyyan.cyyan.GE(cost1) or passive1
	$"level2/active".disabled = !cyyan.cyyan.GE(cost2) or active2
	$"level2/timing".disabled = !cyyan.cyyan.GE(cost2) or timing2
	$"level2/passive".disabled = !cyyan.cyyan.GE(cost2) or passive2
	$"level3/active".disabled = !cyyan.cyyan.GE(cost3) or active3
	$"level3/passive".disabled = !cyyan.cyyan.GE(cost3) or passive3
	$"level4/active".disabled = !cyyan.cyyan.GE(cost4) or active4
	$"level4/timing".disabled = !cyyan.cyyan.GE(cost4) or timing4
	$"level4/passive".disabled = !cyyan.cyyan.GE(cost4) or passive4

func updateText():
	visible = cyyan.milestones.stage > 4
	$"level1/active".text = "Every second click has effect x22
Every third click has effect x3
Every fourth click has effect x4" + ("" if active1 else "\nCosts " + cost1.F("cyyan thing", true))
	$"level1/passive".text = "Time since last click grows
"+Dec.D(4).F("",true)+"x as fast" + ("" if passive1 else "\nCosts " + cost1.F("cyyan thing", true))
	$"level2/active".text = "Multiplier to clicks
decreases with time since
last click
"+("Currently " if active2 else "")+"x" + game.things.clicks.active2.F() + ("" if active2 else "\nCosts " + cost2.F("cyyan thing", true))
	$"level2/timing".text = "Multiplier to clicks
increases with time since
last click
"+("Currently " if timing2 else "")+"x" + game.things.clicks.timing2.F() + ("" if timing2 else "\nCosts " + cost2.F("cyyan thing", true))
	$"level2/passive".text = Dec.D(0.1).F("",true)+"x of
things per click
is added to TPS" + ("
Currently +" + game.things.passive2.F("", true) if passive2 else "\nCosts " + cost2.F("cyyan thing", true))
	$"level3/active".text = "Funny Upgrade 2 starts at 1s" + ("" if active3 else "\nCosts " + cost3.F("cyyan thing", true))
	$"level3/passive".text = "+^0.1 boost to milestone 3" + ("" if passive3 else "\nCosts " + cost3.F("cyyan thing", true))
	$"level4/active".text = "Boost to things per click
increases by +^0.05 per click
decreases by +^0.3 per second
" + ("Currently +^"+game.things.clicks.active4.F()+"\n(cap"+("ped" if game.things.clicks.active4.GreaterThan(0.55) else "")+" at +^0.6)" if active4 else "(cap at +^0.6)\nCosts " + cost4.F("cyyan thing", true))
	$"level4/timing".text = "Softcap of Funny Upgrade 2 is
moved to " + Dec.D(300).FT(true) + ("" if timing4 else "\nCosts " + cost4.F("cyyan thing", true))
	$"level4/passive".text = "Time since last click grows faster
based on time since last click
" + ("Currently " if passive4 else "")+"x" + game.things.clicks.passive4.F() + ("" if passive4 else "\nCosts " + cost4.F("cyyan thing", true))

func _active1_pressed():
	cyyan.costCyyan(cost1)
	active1 = true
	updateChoices()

func _passive1_pressed():
	cyyan.costCyyan(cost1)
	passive1 = true
	updateChoices()

func _active2_pressed():
	cyyan.costCyyan(cost2)
	active2 = true
	updateChoices()

func _timing2_pressed():
	cyyan.costCyyan(cost2)
	timing2 = true
	updateChoices()

func _passive2_pressed():
	cyyan.costCyyan(cost2)
	passive2 = true
	updateChoices()

func _active3_pressed():
	cyyan.costCyyan(cost3)
	active3 = true
	updateChoices()

func _passive3_pressed():
	cyyan.costCyyan(cost3)
	passive3 = true
	updateChoices()

func _active4_pressed():
	cyyan.costCyyan(cost4)
	active4 = true
	game.achievements.unlockAch("cyyan", 6, "a")
	updateChoices()

func _timing4_pressed():
	cyyan.costCyyan(cost4)
	timing4 = true
	game.achievements.unlockAch("cyyan", 6, "b")
	updateChoices()

func _passive4_pressed():
	cyyan.costCyyan(cost4)
	passive4 = true
	game.achievements.unlockAch("cyyan", 6, "c")
	updateChoices()


func save():
	return {
		"node" : self.name,
		"active1" : self.active1,
		"passive1" : self.passive1,
		"active2" : self.active2,
		"timing2" : self.timing2,
		"passive2" : self.passive2,
		"active3" : self.active3,
		"passive3" : self.passive3,
		"active4" : self.active4,
		"timing4" : self.timing4,
		"passive4" : self.passive4,
	}
