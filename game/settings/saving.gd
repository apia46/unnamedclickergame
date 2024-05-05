extends HBoxContainer
@onready var game = $"/root/game"

var autosaveInterval : int = 30
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("b"):
			_loadFromBackupButton_pressed()

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

func updateText():
	$"main/autosave/interval/intervalLabel".text = ("none" if autosaveInterval == 0 else Dec.D(autosaveInterval).FT(true))
	$"main/autosave/intervalLabel".text = "Autosave Interval (0 for none) " + ("" if autosaveInterval == 0 else Dec.D(game.timeSinceSave).FT(false, 1) + " since save")

func save():
	return {
		"node" : self.name,
		"autosaveInterval" : autosaveInterval,
	}
