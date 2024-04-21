extends VBoxContainer
@onready var reference # references to other nodes

var uiScalingSliderValue : float = 1
# computed
@onready var computed # computed vars

func _ready(): pass # likely just pass

func setFromData():
	$"scaling/uiScalingSlider".value = uiScalingSliderValue

# processes here

func _uiScalingSlider_changed(value_changed):
	uiScalingSliderValue = $"scaling/uiScalingSlider".value
	updateScaling()

func updateScaling():
	get_window().content_scale_factor = uiScalingSliderValue

func updateText():
	$"scaling/scalingLabel".text = str(round($"scaling/uiScalingSlider".value*100)) + "%"

func save():
	return {
		"nodepath" : self.get_path(),
		"uiScalingSliderValue" : uiScalingSliderValue,
	}
