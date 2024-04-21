extends hover

var text = ""

func set_data(Text):
	text = Text
	name = "hoverInstance"
	return self

func updateText():
	super()
	$"cont/text".text = text
