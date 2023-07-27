extends Control
@onready var achiev = get_node("/root/game/tabs/acheivemetns")

func _pressed():
	achiev.achs[13].unlock()
