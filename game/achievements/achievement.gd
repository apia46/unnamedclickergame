extends TextureRect
@onready var reference # references to other nodes
const TEXTHOVER = preload("res://assets/ui/textHover.tscn")

var id : String
var unlocked = false
var hoverInstance
# computed
@onready var unlockedImg = load("res://assets/achievements/" + id + ".png")
var lockedImg = preload("res://assets/achievements/-.png")
var title = ""
var desc = ""

func _ready(): pass # likely just pass

func set_data(Id,Unlocked:=false):
	id = Id
	unlocked = Unlocked
	return self

# processes here

func _hoverStart():
	hoverInstance = TEXTHOVER.instantiate()
	$"/root".add_child.call_deferred(hoverInstance)

func _hoverEnd():
	hoverInstance.queue_free()

func updateText():
	match id:
		"basic0":
			title = "Yep, theres an achievement system"
			desc = "Click the button\n[i]what did you expect? This is a clicker game[/i]"
	if unlocked: texture = unlockedImg
	else: texture = lockedImg
	if hoverInstance != null: hoverInstance.set_data("[font_size=16]"+title+"[/font_size]\n"+(desc if unlocked else "???"))
