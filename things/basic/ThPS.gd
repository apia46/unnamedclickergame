extends RichTextLabel

@onready var n = Dec.D(0)

func _process(d):
	# calculating things per second
	var nC = %ThG.n.Clone()
	nC.Mulr(%ThGM.n)
	n = nC
	
	text = "and get "+n.F()+" things per second"
	%Things.n.Incr(n.Mul(d))
