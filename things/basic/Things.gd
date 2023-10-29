extends RichTextLabel

@onready var n = Dec.D(0)

func _process(_delta):
	text = "You have "+n.F()+" things"
