extends uiPopup

var img
var title = ""
var desc = ""

func set_data(Img, Title, Desc):
	img = Img
	title = Title
	desc = Desc
	$"cont/cont/image".texture = img
	$"cont/cont/textCont/titleLabel".text = title
	$"cont/cont/textCont/descLabel".text = desc
	return self
