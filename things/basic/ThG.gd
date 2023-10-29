extends Button

@onready var n = Dec.D(0)
@onready var cost = Dec.D(200)

func _process(_d):
	disabled = !%Things.n.GE(cost)
	text = "Thing Generator ("+n.F()+")\nCosts "+cost.F()+" things"

func c():
	if !%Things.n.GE(cost): return
	n.Incr(1)
	%Things.n.Decr(cost)
	cost = Dec.D(200).Mul(Dec.D(1.1).PowOf(n))
