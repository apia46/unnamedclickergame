extends VBoxContainer
@onready var reference # references to other nodes
const ARROWRIGHT = preload("res://assets/ui/arrowRight.tres")
const ARROWDOWN = preload("res://assets/ui/arrowDown.tres")

@onready var variables # variables, line breaks to section things
# computed
@onready var cont = $cont

func _ready(): cont.visible = true

func add(child):
	cont.add_child(child)
	return child

# processes here

func _dropdownButton_toggled(toggled_on):
	if toggled_on: $dropdownButton.icon = ARROWDOWN
	else: $dropdownButton.icon = ARROWRIGHT
	cont.visible = toggled_on

func updateText(text):
	$dropdownButton.text = text

func save():
	return {
		"nodepath" : self.get_path(),
	}
