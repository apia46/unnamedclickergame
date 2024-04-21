extends PanelContainer

func _ready():
	add_to_group("hover")

func updateText():
	position = get_viewport().get_mouse_position()+Vector2(10,0)
