# meta-description: Base template for this game

extends _BASE_
@onready var reference # references to other nodes

@onready var variables # variables, line breaks to section things
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

# functions here

# processes here

# _listeners here

# updates here

func save():
	return {
		"node" : self.name,
	}
