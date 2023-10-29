extends Button

@onready var n = Dec.D(1)
@onready var cost = Dec.D(10)
@onready var add = Dec.D(1)

func _process(_d):
	disabled = !%Things.n.GE(cost)
	text = "Generator Multiplier\nx"+n.F()+" [+"+add.F()+"]\nCosts "+cost.F()+" generators"
