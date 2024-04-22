extends VBoxContainer
@onready var game = $"/root/game"

var formattingOptionsSelected : int = 0
var seperatorOptionsSelected : int = 0
var digitsShownOptionsValue : int = 2
var preventFlickeringValue = true
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

func setFromData():
	$"formattingOptions".selected = formattingOptionsSelected
	$"seperatorOptions".selected = seperatorOptionsSelected
	$"digitsShown/digitsShownOptions".value = digitsShownOptionsValue
	$"preventFlickering".button_pressed = preventFlickeringValue
	updateFormatting()

# processes here

func _formattingOptions_select(index):
	formattingOptionsSelected = index
	updateFormatting()

func _seperatorOptions_select(index):
	seperatorOptionsSelected = index
	updateFormatting()

func _digitsShownOptions_changed(value):
	digitsShownOptionsValue = value
	updateFormatting()

func _preventFlickering_toggled(toggled):
	preventFlickeringValue = toggled
	updateFormatting()

func updateFormatting():
	match formattingOptionsSelected:
		0: Dec.format = Dec.SCIENTIFIC
		1: Dec.format = Dec.STANDARD
		2: Dec.format = Dec.STANDARDFULL
		3: Dec.format = Dec.LONG
		4: Dec.format = Dec.BLIND; game.achievements.unlockAch("secret",1)
		_: print("invalid formatting option")
	match seperatorOptionsSelected:
		0: Dec.seperator = Format.SEPERATOR.COMMA; Dec.decimalPoint = Format.SEPERATOR.PERIOD
		1: Dec.seperator = Format.SEPERATOR.PERIOD; Dec.decimalPoint = Format.SEPERATOR.COMMA
		2: Dec.seperator = Format.SEPERATOR.NONE; Dec.decimalPoint = Format.SEPERATOR.PERIOD
		3: Dec.seperator = Format.SEPERATOR.NONE; Dec.decimalPoint = Format.SEPERATOR.COMMA
	Dec.digitsShown = digitsShownOptionsValue
	Dec.preventFlickering = preventFlickeringValue

func updateText():
	$"formattingExample".text = "Example: "+Dec.D(123456789.0123456789).F()

func save():
	return {
		"nodepath" : self.get_path(),
		"formattingOptionsSelected" : formattingOptionsSelected,
		"seperatorOptionsSelected" : seperatorOptionsSelected,
		"digitsShownOptionsValue" : digitsShownOptionsValue,
	}
