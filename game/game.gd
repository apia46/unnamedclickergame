# Structure notes:

# variables/code/listeners should belong to the node they are most relevant to, there should usually be a container general enough but not too general for this purpose
# if there isnt, maybe it would be best to put the relevant ui elements closer together
# if there is a chain of containers, pick the most nested one

extends TabContainer
@onready var things = %things
@onready var settings = %settings

const BACKUPDIRECTORY = "user://backup.save" # debug
const SAVEDIRECTORY = "user://savegame.save"
const TEMPSAVEDIRECTORY = "user://tempsavegame.save"
const THINGSCONT = preload("res://game/thingsCont.tscn")
const CYYAN = preload("res://game/cyyan/cyyan.tscn")
enum UNLOCK {NONE, CYYAN}

@onready var timePlayed = Dec.D(0)
var timeSaved = 0.0
var cyyanUnlocked = false
# computed
var timeSinceAutosave = 0.0
var thingsCont
var cyyan

func _ready(): update()

func _process(delta):
	# here is the main processing of the game
	# all things that happen by procedure in a frame should go here
	
	# PROCESSING
	timePlayed.Incr(delta)
	things.clicks.procTimeSinceClick(delta)
	if cyyanUnlocked: cyyan.procCyyan()
	things.generators.procGens()
	things.procTPS(delta)
	things.clicks.procThingsPerClick()
	
	# UPDATE VISUALS
	# make sure the right tabs are disabled; make sure tabs are named correctly
	updateTabs()
	# update button disabling
	things.updateButtons()
	if cyyanUnlocked: cyyan.updateButtons()
	# update the text on everything
	things.updateText()
	if cyyanUnlocked: cyyan.updateText()
	settings.updateText()
	
	# autosaving
	timeSinceAutosave += delta
	if timeSinceAutosave > settings.saving.autosaveInterval*60 and settings.saving.autosaveInterval != 0:
		initiateSave(true)
		timeSinceAutosave = 0

func updateTabs(unlock:=UNLOCK.NONE):
	if unlock == UNLOCK.CYYAN: cyyanUnlocked = true
	set_tab_title(0, "Things")
	set_tab_title(1, "Settings")
	set_tab_title(2, "Information")
	if cyyanUnlocked:
		if has_node(^"things"):
			# surgery
			thingsCont = THINGSCONT.instantiate()
			add_child(thingsCont)
			move_child(thingsCont, 0)
			remove_child(things)
			thingsCont.add_child(things)
			cyyan = CYYAN.instantiate()
			thingsCont.add_child(cyyan)
			update()
		thingsCont.set_tab_title(0, "Basic")
		thingsCont.set_tab_title(1, "Cyyan")

func initiateSave(autosaved:=false, toClipboard:=false):
	timeSaved = Time.get_unix_time_from_system()
	update()
	var save_file : FileAccess
	if toClipboard: save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.WRITE)
	else: save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.WRITE)
	
	save_file.store_line(JSON.stringify(save()))
	save_file.store_line(JSON.stringify(things.save()))
	save_file.store_line(JSON.stringify(things.generators.save()))
	save_file.store_line(JSON.stringify(things.clicks.save()))
	save_file.store_line(JSON.stringify(things.funnyUpgs.save()))
	if cyyanUnlocked:
		save_file.store_line(JSON.stringify(cyyan.save()))
		save_file.store_line(JSON.stringify(cyyan.milestones.save()))
	
	save_file.store_line(JSON.stringify(settings.save()))
	save_file.store_line(JSON.stringify(settings.formatting.save()))
	save_file.store_line(JSON.stringify(settings.saving.save()))
	if toClipboard:
		save_file.close()
		save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.READ)
		DisplayServer.clipboard_set(save_file.get_as_text())
	print(("auto" if autosaved else "") + "saved")

func initiateLoad(fromClipboard:=false, fromBackup:=false):
	if not FileAccess.file_exists(SAVEDIRECTORY):
		print("there is no save file")
		return
	
	var save_file : FileAccess
	if fromClipboard:
		save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.WRITE)
		save_file.store_string(DisplayServer.clipboard_get())
		save_file.close()
	if fromBackup: save_file = FileAccess.open(BACKUPDIRECTORY, FileAccess.READ)
	else: save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# [Creates the helper class to interact with JSON]
		var json = JSON.new()
		
		# so json.parse sets json to the parsed of json_string. i see
		var check = json.parse(json_string)
		# [Check if there is any error while parsing the JSON string, skip in case of failure]
		if !(check == OK):
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			print("please send save file; JSON Parse Error: " + json.get_error_message() + " in save file at line " + str(json.get_error_line()))
			return
		
		var node_data = json.get_data()
		for variable in node_data.keys():
			if variable != "nodepath":
				if typeof(node_data[variable]) == TYPE_ARRAY and node_data[variable][0] == "Decimal": get_node(node_data["nodepath"]).set(variable, Dec.fromArray(node_data[variable]))
				else: get_node(node_data["nodepath"]).set(variable, node_data[variable])
		if node_data["nodepath"] == "/root/game": updateTabs()
	update()
	print("loaded successfully")


func update(): # for one time updates; this is an "update all"
	things.funnyUpgs.update()
	if cyyanUnlocked: cyyan.milestones.update()
	settings.setFromData()

func save():
	return {
		"nodepath" : self.get_path(),
		"timePlayed" : timePlayed.asArray(),
		"timeSaved" : timeSaved,
		"cyyanUnlocked" : cyyanUnlocked
	}
