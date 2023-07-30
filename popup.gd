extends Control


func newsidepopup(text):
	add_child(sidepopup.new(text,0,0))


class popup:
	extends Panel
	
	var text
	
	func _ready():
		size = text.size
	
	func _init(Text, x := 0, y := 0):
		theme = load("res://themes/solidbg.tres")
		text = Label.new()
		add_child(text)
		position.x = x
		position.y = y
		text.text = Text


class sidepopup:
	extends popup
	@onready var tween = get_tree().create_tween()
	
	var basey = 0
	var addedy = 0
	#sin
	func _process(_delta):
		position.y = basey + addedy
	
	func _ready():
		size = text.size
		position.x = get_window().size.x
		tween.tween_property(self, "position:x", -size.x, 0.75).as_relative().set_trans(Tween.TRANS_SINE)
		tween.tween_interval(1)
		tween.tween_property(self, "addedy", get_window().size.y-position.y, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
		tween.tween_callback(queue_free)
		add_to_group("sidepopup")
		get_tree().call_group("sidepopup", "shuffle")
	
	func shuffle():
		basey += 30
