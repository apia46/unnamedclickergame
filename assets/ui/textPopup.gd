extends uiPopup

var text = ""

func set_data(Text):
	text = Text
	$"cont/text".text = text
	return self
