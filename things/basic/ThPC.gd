extends Button

@onready var n = Dec.D(1)
@onready var timeSince = Dec.D(0)

func _process(d):
	timeSince.Incr(d)
	
	var nC = Dec.D(100)
	nC = nC.Add(%MThPC.n)
	if %FU.n>1: nC = nC.Mul(%FU.e1)
	n = nC
	
	text = "Thing Button\nYou will get "+n.F()+" things"

func c():
	%Things.n.Incr(n)
	timeSince = Dec.D(0)
