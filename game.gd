extends Node

var format = preload("format.gd").new()
@onready var things = get_node("/root/game/tabs/things/normal")
@onready var cyyan = get_node("/root/game/tabs/things/cyyan")
@onready var settings = get_node("/root/game/tabs/settings")
@onready var informateion = get_node("/root/game/tabs/informateion")
@onready var achiev = get_node("/root/game/tabs/acheivemetns")
@onready var popup = get_node("/root/game/popup")

const SAVEDIRECTORY = "user://savegame.save"

var time = float(0)

var automatortime = float(0)
var automatortick = float(5)
var automatorbulk = float(50)

var autosavetime = float(0)

var donttouchypls = ""
var timeSaved

var loadpanel
var autosaveOverride = false

func _ready():
	_update_all()
	if FileAccess.file_exists(SAVEDIRECTORY):
		autosaveOverride = true
		load_panel()

func _process(delta):
	# process the numbers
	things.processthings(delta)
	cyyan.processcyyan(delta)
	
	if automatortime >= automatortick:
		automatortime -= automatortick
		_trigger_automators()
	if autosavetime >= settings.autosaveinterval and settings.autosaveinterval > 0 and !autosaveOverride:
		autosavetime = 0
		_save(true)
	# then change the text
	get_tree().call_group("toupdateperframe", "_update_per_frame")
	
	# then advance the clock
	time += delta
	automatortime += delta
	autosavetime += delta
	
	# oh and
	if time >= 1800: achiev.achs[12].unlock()

func _trigger_automators():
	for i in range(automatorbulk):
		if cyyan.automatedpassive and !get_node("/root/game/tabs/things/normal/passivethingbuy").disabled: things._passivethingbuy()

func load_panel():
	loadpanel = Panel.new()
	@warning_ignore("integer_division")
	loadpanel.position.x = get_window().size.x/2-150
	@warning_ignore("integer_division")
	loadpanel.position.y = get_window().size.y/2-100
	loadpanel.size.x = 300
	loadpanel.size.y = 200
	loadpanel.theme = load("res://solidbg.tres")
	add_child(loadpanel)
	var loadtext = Label.new()
	loadtext.text = "yo, you have a save file,\nwould you like to load it?"
	loadtext.position.x = 50
	loadtext.position.y = 50
	loadpanel.add_child(loadtext)
	var loadyea = Button.new()
	loadyea.text= "yea"
	loadyea.position.x = 50
	loadyea.position.y = 125
	loadyea.size.x = 50
	loadyea.size.y = 25
	loadpanel.add_child(loadyea)
	loadyea.pressed.connect(self._panelload)
	var loadnah = Button.new()
	loadnah.text= "nah"
	loadnah.position.x = 200
	loadnah.position.y = 125
	loadnah.size.x = 50
	loadnah.size.y = 25
	loadpanel.add_child(loadnah)
	loadnah.pressed.connect(loadpanel.queue_free)

func _panelload():
	_load()
	loadpanel.queue_free()
	autosaveOverride = false

func _paneldont():
	loadpanel.queue_free()
	autosaveOverride = false

func _save(autosaved:=false):
	if !autosaved: achiev.achs[11].unlock()
	timeSaved = Time.get_unix_time_from_system()
	_update_all()
	var save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save()))
	save_file.store_line(JSON.stringify(settings.save()))
	save_file.store_line(JSON.stringify(informateion.save()))
	save_file.store_line(JSON.stringify(achiev.save()))
	save_file.store_line(JSON.stringify(things.save()))
	save_file.store_line(JSON.stringify(cyyan.save()))
	popup.newsidepopup(("auto" if autosaved else "") + "saved successfully")

func _load():
	if not FileAccess.file_exists(SAVEDIRECTORY):
		print("there is no save file")
		return
	
	var save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# [Creates the helper class to interact with JSON]
		var json = JSON.new()
		
		# so json.parse sets json to the parsed of json_string. i see
		var check = json.parse(json_string)
		# [Check if there is any error while parsing the JSON string, skip in case of failure]
		if !(check == OK):
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			popup.newsidepopup("please send save file; JSON Parse Error: " + json.get_error_message() + " in save file at line " + str(json.get_error_line()))
			return
		
		var node_data = json.get_data()
		for variable in node_data.keys():
			if variable != "nodepath": get_node(node_data["nodepath"]).set(variable, node_data[variable])
	settings._update_all()
	achiev._update_all()
	_update_all()
	popup.newsidepopup("loaded successfully")


func _update_all():
	get_tree().call_group("toupdateall", "_update_all")

func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"donttouchypls" : "its no fun",
		"timeSaved" : timeSaved,
		"time" : time,
		"automatortick" : automatortick,
		"automatorbulk" : automatorbulk,
	}
	return save_dict
