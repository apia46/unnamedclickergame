extends Control
@onready var hover = get_node("/root/game/hover")
@onready var achcontainer = get_node("/root/game/tabs/acheivemetns/achcontaner/achievementcontainer")
@onready var format = get_node("/root/game").format
@onready var things = get_node("/root/game/tabs/things/normal")
@onready var cyyan = get_node("/root/game/tabs/things/cyyan")

var achs = []
var achieved = []
var amount = 0
const HEIGHT = 7
const WIDTH = 7

func _ready():
	achcontainer.columns = WIDTH
	for i in range(HEIGHT*WIDTH):
		var current = achievement.new(i)
		achs.append(current)
		achieved.append(false)
		achcontainer.add_child(current)

func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"achieved" : achieved,
		"amount" : amount
	}
	return save_dict

func _update_all():
	for i in achs:
		i._update_all()
	_update_ach()

func _update_ach():
	%achinfo.text = "achievements are given for whatever i want to give them for" + ((", and give a multiplier to your things\ncurrently: x" + str(amount**cyyan.achievexponent)) if things.funnyupgradebuttonstage >= 3 else "")

class achievement:
	extends TextureButton
	@onready var achiev = get_node("/root/game/tabs/acheivemetns")
	@onready var popup = get_node("/root/game/popup")
	@onready var hover = get_node("/root/game/hover")
	@onready var format = get_node("/root/game").format
	
	var achname = ""
	var id = ""
	var loc: int
	var desc = ""
	var secret = 0
	var unlocked = false
	var text = "yo"
	
	
	func _ready():
		_update_all()
		self.mouse_entered.connect(hover._mouse_entered.bind("ach", text))
		self.mouse_exited.connect(hover._mouse_exited)
		if id == "06": self.pressed.connect(self.unlock)
	
	func _init(location):
		loc = location
		@warning_ignore("integer_division")
		id = str(loc/7) + str(loc%7)
		texture_normal = load("res://assets/ach/-.png")
	
	func unlock():
		if unlocked: return
		popup.newsidepopup("achievemetn: " + achname)
		achiev.amount += 1
		if id == "06":
			hover._update_hover("ach", text)
		loadunlock()
	
	func loadunlock():
		achiev._update_ach()
		texture_normal = load("res://assets/ach/" + id + ".png")
		unlocked = true
		achiev.achieved[loc] = true
		text = achname + "\n" + desc
		self.mouse_entered.disconnect(hover._mouse_entered)
		self.mouse_entered.connect(hover._mouse_entered.bind("ach", text))
	
	func _update_all():
		match id:
			"00":
				achname = "click the button"
				desc = "its like, the only button you can\nclick that does anything..."
			"01":
				achname = "whats next, tetration?"
				desc = "buy an exponential passive generation boost"
			"02":
				achname = "not worth it"
				desc = "do a things sacrifice and get\nless than 1.5x of a boost"
			"03":
				achname = "its not that funny"
				desc = "buy the first funny upgrade"
			"04":
				achname = "no- like, youre supposed to wait for it"
				desc = "have the first funny upgrade boost\nand spam the thing button"
			"05":
				achname = "i have to do the math myself???"
				desc = "buy the second funny upgrade"
			"06":
				achname = "yes of course there is one where\nyou click it and its free"
				desc = "what did you expect this is\na clicker game lol"
				secret = 2
			"10":
				achname = ":boom:"
				desc = "get more than " + format.number(10000) + " things in one click"
			"11":
				achname = "what did you do to my numbers???"
				desc = "trigger the scientific number notation"
			"12":
				achname = "this is taking a while"
				desc = "have 69 non-bonus passive thing generators (nice)"
			"13":
				achname = "owo whats this"
				desc = "unlock cyyan"
				secret = 1
			"14":
				achname = "just in case :)"
				desc = "save the game manually"
				secret = 1
			"15":
				achname = "where did time go?"
				desc = "have played for 30 minutes"
			"16":
				achname = "eg"
				desc = "blame clicktuck"
				secret = 2
			"20":
				achname = "achievementception"
				desc = "buy the third funny upgrade"
			"21":
				achname = "things were going slow so im speeding it up for you"
				desc = "buy the first cyyan upgrade"
				secret = 1
			_:
				visible = false
		unlocked = achiev.achieved[loc]
		if unlocked: loadunlock()
		match secret:
			0: text = achname + "\n" + desc
			1: text = achname + "\n???"
			2: text = "secret achievement\n???"
