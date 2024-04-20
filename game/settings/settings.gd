extends MarginContainer
@onready var formatting = $"cont/topside/cont/formatting"
@onready var saving = $"cont/topside/cont/saving"
@onready var scaling = $"cont/midside/uiScaling"

@onready var variables # variables, line breaks to section things
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

# functions here

# processes here

func setFromData():
	formatting.setFromData()
	saving.setFromData()
	scaling.setFromData()

func updateText():
	formatting.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
	}
