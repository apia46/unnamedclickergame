extends Button
@onready var parent = get_parent()

var id
var cost
var effect
var bought = false
# computed
@onready var computed # computed vars

func _ready():
	match id:
		0:
			cost = Dec.D(1000)
			effect = "x2 generators"
		1:
			cost = Dec.D(2000)
			effect = "The second one"
		2:
			cost = Dec.D(3000)
			effect = "The third one"
		3:
			cost = Dec.D(5000)
			effect = "The fourth one"
		4:
			cost = Dec.D(7500)
			effect = "The fifth one"
		5:
			cost = Dec.D(10000)
			effect = "The sixth one"
		_:
			cost = Dec.D(-1)
			effect = "invalid funnyUpg id"

func set_data(Id,Bought:=false):
	id = Id
	bought = Bought
	return self

func _funnyUpg_buy():
	parent.things.costThings(cost)
	bought = true
	parent._funnyUpg_buy()

func updateButtons():
	disabled = bought or parent.things.things.LessThan(cost)

func updateText():
	text = "Funny Upgrade "+str(id+1)+"
"+("costs "+cost.F("thing")+"
" if !bought else "")+(effect if bought else "???")
