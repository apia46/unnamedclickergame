extends Button

@onready var n = 1
@onready var cost = Dec.D(1)

@onready var e1 = Dec.D(1)
@onready var e2 = Dec.D(1)
@onready var e3 = Dec.D(1)

func _process(_d):
	# upg 1
	var tS = %ThPC.timeSince
	if tS.L(3): e1 = tS.Squared().Mul(4).Add(1)
	else:
		e1 = tS.Mul(3).Add(tS.Neg().Add(2.8).Rc()).Add(33)
	
	# upg 2
	var gens = %ThG.n
	e2 = gens.PowOf(1.1).Div(2).Add(1)
	
	#upg 3
	e3 = Dec.D(%Things.n.Add(1).Ln())
	
	match n:
		1: cost = Dec.D(1000)
		2: cost = Dec.D(10000)
		3: cost = Dec.D(100000)
	
	#desc = "things gained multiplier (based on achievements)"
	
	text = "Funny Upgrade "+str(n)+"\nCosts "+cost.F()+" things"
	if n > 1: text += "\nEffects:\n"+e1.F()+"x things per click (based on time since last click)"
	if n > 2: text += "\n"+e2.F()+"x generator multiplier (based on generators bought)"
	if n > 3: text += "\n"+e3.F()+"x things per click (based on things)"
	
	disabled = !%Things.n.GE(cost)

func c():
	if !%Things.n.GE(cost): return
	%Things.n.Decr(cost)
	n += 1
