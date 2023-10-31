extends Button

@onready var n = Dec.D(1)
@onready var cost = Dec.D(5)
@onready var add = Dec.D(1)

func _process(_d):
	disabled = !%ThG.n.GE(cost)
	text = "Generator Multiplier\nx"+n.F()+" [+"+add.F()+"]\nCosts "+cost.F()+" generators"

func c():
	if !%ThG.n.GE(cost): return
	n.Incr(add)
	%ThG.n.Decr(cost)
	cost = Dec.D(5).PowOf(Dec.D(1.15).PowOf(n)).Floor()
	
