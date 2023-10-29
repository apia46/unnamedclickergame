extends RichTextLabel

@onready var n = Dec.D(0)

func _process(d):
	n = %ThG.n
	text = "and get "+n.F()+" things per second"
	%Things.n.Incr(n.Mul(d))
