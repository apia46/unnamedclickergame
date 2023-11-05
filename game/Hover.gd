extends PanelContainer

func _process(_d):
	position.x = get_viewport().get_mouse_position().x+10
	position.y = get_viewport().get_mouse_position().y

func new(type, text:=""):
	pass

func del():
	pass
