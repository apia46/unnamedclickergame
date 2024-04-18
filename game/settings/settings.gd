extends MarginContainer
@onready var formatting = $"cont/topside/formatting"

@onready var variables # variables, line breaks to section things
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

# functions here

# processes here

# _listeners here

func updateText():
	formatting.updateText()

