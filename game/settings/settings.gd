extends MarginContainer
@onready var formatting = $"cont/cont/formatting"
@onready var saving = $"cont/cont/topside/cont/main/saving"
@onready var scaling = $"cont/cont/topside/cont/main/main/uiScaling"

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
	saving.updateText()
	scaling.updateText()

func save():
	return {
		"node" : self.name,
	}
