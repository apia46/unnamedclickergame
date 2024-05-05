extends PanelContainer
class_name popup

@onready var tween = get_tree().create_tween()

var addedx = 0
var basey = 0
var addedy = 0

func shuffle(amount):
	basey += amount

func _ready():
	tween.tween_property(self, "addedx", -size.x, 0.75).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_interval(1)
	tween.tween_property(self, "addedy", get_window().size.y-position.y, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	get_tree().call_group("sidepopup", "shuffle", size.y+4)
	add_to_group("sidepopup")

func _process(_delta):
	var windowScale = get_window().content_scale_factor
	scale = Vector2(windowScale,windowScale)
	position.x = int(get_window().size.x/windowScale+addedx*windowScale)
	position.y = basey + addedy
