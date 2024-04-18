extends MarginContainer
@onready var formatting = $"cont/topside/cont/formatting"
@onready var saving = $"cont/topside/cont/saving"

@onready var variables # variables, line breaks to section things
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

# functions here

# processes here

func updateText():
	formatting.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
	}
