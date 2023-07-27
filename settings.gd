extends Control
@onready var format = get_node("/root/game").format
@onready var game = get_node("/root/game")

var numberformattingselected = 0
var autosavevalue = 0
var autosaveinterval = 0

func _update_all():
	%numberformatting.selected = numberformattingselected
	%autosave.value = autosavevalue
	_update_settings()

func _numberformatting(index):
	numberformattingselected = index
	_update_settings()
	game._update_all()

func _autosave(value):
	autosavevalue = value
	_update_settings()
	game._update_all()

func _update_settings():
	match int(numberformattingselected):
		0: format.defaultnumberformat = "scientific"
		_: format.defaultnumberformat = "none"
	match int(autosavevalue):
		0: autosaveinterval = 60
		1: autosaveinterval = 300
		2: autosaveinterval = 600
		3: autosaveinterval = -1

func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"format.defaultnumberformat" : format.defaultnumberformat,
		"numberformattingselected" : numberformattingselected,
		"autosavevalue" : autosavevalue,
	}
	return save_dict
