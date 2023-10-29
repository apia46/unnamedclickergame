extends Button

@onready var n = Dec.D(0)
@onready var cost = Dec.D(1)
@onready var costMultiplier = Dec.D(2)
@onready var add = Dec.D(1)

func _process(_d):
	disabled = !%Things.n.GE(cost)
	text = n.F()+" [+"+add.F()+"] extra things per click \nCosts "+cost.F()+" things"

func c():
	if !%Things.n.GE(cost): return
	n.Incr(add)
	%Things.n.Decr(cost)
	cost.Mulr(costMultiplier)
	costMultiplier.Incr(1)
