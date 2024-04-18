extends HBoxContainer
@onready var game = $"/root/game"

var autosaveInterval = 5
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

# functions here

# processes here

func _saveFileButton_pressed():
	game.initiateSave()

func _loadFileButton_pressed():
	game.initiateLoad()

func _intervalSlider_changed(value):
	autosaveInterval = value


# updates here

func save():
	return {
		"nodepath" : self.get_path(),
	}
