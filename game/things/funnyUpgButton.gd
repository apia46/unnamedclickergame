extends Button
@onready var parent = get_parent()

const CYYANTHEME = preload("res://assets/themes/cyyantheme.tres")

var id : int
var bought = false
# computed
@onready var cost = Dec.D(0)
var effect = ""

func _ready(): pass

func set_data(Id,Bought:=false):
	id = Id
	bought = Bought
	return self

func _funnyUpg_buy():
	if bought: return
	parent.things.costThings(cost)
	bought = true
	parent._funnyUpg_buy()

func updateButtons():
	match id:
		0: cost = Dec.D(1000)
		1: cost = Dec.D(2000)
		2: cost = Dec.D(5000)
		3: cost = Dec.D(10000)
		4: cost = Dec.D(20000)
		5: cost = Dec.D(30000)
		6: cost = Dec.D(60000)
		7: cost = Dec.D(80000)
		8: cost = Dec.D(100000)
		9: cost = Dec.D(1000000)
		10: cost = Dec.D(2000000)
		11: cost = Dec.D(5000000)
		12: cost = Dec.D(1e7)
		13: cost = Dec.D(2e7)
		14: cost = Dec.D(1e8)
		_: cost = Dec.D(0)
	disabled = (bought and id != 12) or (!bought and parent.things.things.LessThan(cost))

func updateText():
	if id > 8: theme = CYYANTHEME
	match id:
		0: effect = "x"+Dec.D(2).Add(parent.things.generators.funnyUpg12).F()+" generators per purchase"
		1: effect = "Things per click multipler\nbased on time since last click\nCurrently x"+parent.things.clicks.funnyUpg2.F()
		2: effect = "The knowledge that these\nupgrades can be \"funny\""
		3: effect = "Total generator output ^"+Dec.D(1.1).Add(parent.things.funnyUpg11).F("",true)
		4: effect = "+"+Dec.D(20001).F("thing", true)+"\n:)"
		5: effect = "Things per click multiplier\nbased on current things\nCurrently x"+parent.things.clicks.funnyUpg6.F()
		6: effect = "+"+Dec.D(59999).F("thing", true)+"\n:("
		7: effect = "+"+Dec.D(parent.things.generators.funnyUpg15).F()+" bonus generator per\nlog 2 of total things\nCurrently +"+parent.things.generators.bonusGens.F() + "\n" + parent.things.generators.untilNextBonus.F("thing") +" until next"
		8: effect = "More things per click effect ^"+Dec.D(2).Add(parent.things.clicks.funnyUpg14).F("",true)
		9: effect = "Unlock cyyan things"
		10: effect = "+^0.01 to upgrade 4\nper generator multiplier\nCurrently +^"+parent.things.funnyUpg11.F()
		11: effect = "Boost to upgrade 1\nbased on cyyan things\nCurrently +x"+parent.things.generators.funnyUpg12.F()
		12: effect = "Button for you to press\nin case you get bored\n:)"
		13: effect = "+0.05 to upgrade 9\nper funny upgrade purchased\nCurrently +^"+parent.things.clicks.funnyUpg14.F()
		14: effect = "Multiplier to upgrade 8\nbased on things per click\nCurrently x"+parent.things.generators.funnyUpg15.F()
		_: effect = "Error: you have too many funny upgs somehow"
	text = "Funny Upgrade "+str(id+1)+"
"+("costs "+cost.F("thing",true)+"
" if !bought else "")+(effect if bought else "???")
