extends HBoxContainer
@onready var game = $"/root/game"

var autosaveInterval : int = 5
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

func setFromData():
	$"main/autosave/interval/intervalSlider".value = autosaveInterval

# processes here

func _saveFileButton_pressed():
	game.initiateSave()

func _saveClipboardButton_pressed():
	game.initiateSave(false, true)

func _loadFileButton_pressed():
	game.initiateLoad()

func _loadClipboardButton_pressed():
	game.initiateLoad(true)

func _intervalSlider_changed(value):
	autosaveInterval = value

func _updateButton_pressed(): # debug
	game.update()

func _loadFromBackupButton_pressed(): # debug
	game.initiateLoad(false, true)

# updates here

func save():
	return {
		"nodepath" : self.get_path(),
		"autosaveInterval" : autosaveInterval,
	}
