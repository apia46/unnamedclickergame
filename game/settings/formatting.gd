extends VBoxContainer
@onready var game = $"/root/game"

var formattingOptionsSelected : int = 0
var seperatorOptionsSelected : int = 0
var digitsShownOptionsValue : int = 2
var preventFlickeringValue = true

var timeSeperatorOptionsSelected : int = 1
var timeUnitsShownOptionsValue : int = 2
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

func setFromData():
	$"number/formattingOptions".selected = formattingOptionsSelected
	$"number/seperatorOptions".selected = seperatorOptionsSelected
	$"number/digitsShown/digitsShownOptions".value = digitsShownOptionsValue
	$"number/preventFlickering".button_pressed = preventFlickeringValue
	
	$"time/seperatorOptions".selected = timeSeperatorOptionsSelected
	$"time/unitsShown/unitsShownOptions".value = timeUnitsShownOptionsValue
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


func _timeSeperatorOptions_select(index):
	timeSeperatorOptionsSelected = index
	updateFormatting()

func _timeUnitsShownOptions_changed(value):
	timeUnitsShownOptionsValue = value
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
	
	match timeSeperatorOptionsSelected:
		0: Dec.timeAnd = false; Dec.timeCommas = false; Dec.timeOxford = false
		1: Dec.timeAnd = false; Dec.timeCommas = true; Dec.timeOxford = true
		2: Dec.timeAnd = true; Dec.timeCommas = true; Dec.timeOxford = false
		3: Dec.timeAnd = true; Dec.timeCommas = false; Dec.timeOxford = false
		4: Dec.timeAnd = true; Dec.timeCommas = true; Dec.timeOxford = true
	Dec.timeUnits = timeUnitsShownOptionsValue

func updateText():
	$"number/formattingExample".text = "Example: "+Dec.D(123456789.0123456789).F()
	$"time/formattingExample".text = "Example: "+Dec.D(123456789.0123456789).FT()

func save():
	return {
		"node" : self.name,
		"formattingOptionsSelected" : formattingOptionsSelected,
		"seperatorOptionsSelected" : seperatorOptionsSelected,
		"digitsShownOptionsValue" : digitsShownOptionsValue,
		"timeSeperatorOptionsSelected" : timeSeperatorOptionsSelected,
		"timeUnitsShownOptionsValue" : timeUnitsShownOptionsValue,
	}
