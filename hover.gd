extends Panel
@onready var format = get_node("/root/game").format
@onready var game = get_node("/root/game")

var hover = 0
var override = false
var lastnode = ""
var lasttext = ""


func _update_all():
	_update_per_frame()

func _update_per_frame():
	size = %text.size
	position.x = get_viewport().get_mouse_position().x+10
	position.y = get_viewport().get_mouse_position().y
	# maybe...
	_update_hover()

func _update_hover(node="last",text="last"):
	if node == "last": node = lastnode
	else: lastnode = node
	# this is stupid i hate this
	if text == "last": text = lasttext
	else: lasttext = text
	override = false
	match node:
		"save":
			if game.timeSaved == null: override = true
			else: %text.text = "Last saved: " + str(format.time(int(Time.get_unix_time_from_system()-game.timeSaved))) + " ago"
		"ach":
			# not happy with this
			if text == "\n": override = true
			else: %text.text = text
		_:
			%text.text = "this id doesnt have text attached to it... (its " + str(node) + ", text is " + str(text) + ")"
	
	visible = (hover >= 1) and !override


func _mouse_entered(node, text:=""):
	hover += 1
	_update_hover(node,text)

func _mouse_exited():
	hover -= 1
	_update_hover("")
