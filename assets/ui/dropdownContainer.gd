extends VBoxContainer
@onready var reference # references to other nodes
const ARROWRIGHT = preload("res://assets/ui/arrowRight.tres")
const ARROWDOWN = preload("res://assets/ui/arrowDown.tres")

@onready var variables # variables, line breaks to section things
# computed
@onready var cont = $"cont/cont"
@export var secret = false

func _ready():
	cont.visible = !secret
	if secret: $dropdownButton.icon = null
	if secret: $dropdownButton.button_pressed = false

func add(child):
	cont.add_child(child)
	return child

# processes here

func _dropdownButton_toggled(toggled_on):
	if toggled_on: $dropdownButton.icon = ARROWDOWN
	else: $dropdownButton.icon = ARROWRIGHT
	if secret: $dropdownButton.icon = null
	cont.visible = toggled_on

func updateText(text):
	$dropdownButton.text = text

func save():
	return {
		"nodepath" : self.get_path(),
	}
