extends Button
@onready var parent = get_parent()

var id
var cost
var effect
var bought = false
# computed
@onready var computed # computed vars

func _ready(): pass

func set_data(Id,Bought:=false):
	id = Id
	bought = Bought
	return self

func _funnyUpg_buy():
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
		5: cost = Dec.D(40000)
		6: cost = Dec.D(60000)
		7: cost = Dec.D(80000)
		_: cost = Dec.D(0)
	disabled = bought or parent.things.things.LessThan(cost)

func updateText():
	match id:
		0: effect = "x2 generators per purchase"
		1: effect = "Things per click multipler\nbased on time since last click\nCurrently x"+parent.things.clicks.funnyUpg2.F()
		2: effect = "The knowledge that these\nupgrades can be \"funny\""
		3: effect = "Total generator output ^1.1"
		4: effect = "+20001 things\n:)"
		5: effect = "Things per click multiplier\nbased on current things\nCurrently x"+parent.things.clicks.funnyUpg6.F()
		6: effect = "+59999 things\n:("
		7: effect = "+1 bonus generator per\npower of 2 of things you get\nCurrently +"
		_: effect = "Error: you have too many funny upgs somehow"
	text = "Funny Upgrade "+str(id+1)+"
"+("costs "+cost.F("thing")+"
" if !bought else "")+(effect if bought else "???")
