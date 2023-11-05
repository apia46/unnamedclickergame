extends Button

@onready var n = Dec.D(1)
@onready var timeSince = Dec.D(0)

func _process(d):
	timeSince.Incr(d)
	
	# calculating things per click
	var nC = Dec.D(1)
	nC.Incr(%MThPC.n)
	if %FUpg.n>1: nC.Mulr(%FUpg.e1)
	if %FUpg.n>3: nC.Mulr(%FUpg.e3)
	n = nC
	
	text = "Thing Button\nYou will get "+n.F()+" things"

func c():
	%Things.n.Incr(n)
	timeSince = Dec.D(0)
