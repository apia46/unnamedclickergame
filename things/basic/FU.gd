extends Button

@onready var n = 1
var desc = "a\na +"
@onready var cost = Dec.D(1)

@onready var e1 = Dec.D(1)

func _process(_d):
	
	# upg 1
	var tS = %ThPC.timeSince
	if tS.L(3): e1 = tS.Squared().Mul(4).Add(1)
	else:
		e1 = tS.Mul(3).Add(tS.Neg().Add(2.8).Rc()).Add(33)
	
	var effect = Dec.D(1)
	match n:
		1:
			cost = Dec.D(1000)
			desc = "things per click multiplier\nbased on time since last click\nx"
			effect = e1
		2:
			cost = Dec.D(20000)
			desc = "every 2x things you get\ngrants you a free thing generator"
		3:
			cost = Dec.D(80000)
			desc = "things gained multiplier\nbased on achievements\nx"
	
	text = "Funny Upgrade "+str(n)+"\n"+desc+effect.F()+"\nCosts "+cost.F()+" things"
	
	disabled = !%Things.n.GE(cost)

func c():
	if !%Things.n.GE(cost): return
	%Things.n.Decr(cost)
	n += 1
