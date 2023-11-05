extends Button

@onready var n = Dec.D(0)
@onready var nM = Dec.D(1)
@onready var cost = Dec.D(200)

func _process(_d):
	disabled = !%Things.n.GE(cost)
	text = "Thing Generator ("+n.F()+")\nCosts "+cost.F()+" things"
	cost = Dec.D(200).Mul(Dec.D(1.2).PowOf(n))
	
	var nMC = Dec.D(1)
	nMC.Mulr(%ThGM.n)
	if %FUpg.n>2: nMC.Mulr(%FUpg.e2)
	nM = nMC

func c():
	if !%Things.n.GE(cost): return
	n.Incr(1)
	%Things.n.Decr(cost)
