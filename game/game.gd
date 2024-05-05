# Structure notes:

# variables/code/listeners should belong to the node they are most relevant to, there should usually be a container general enough but not too general for this purpose
# if there isnt, maybe it would be best to put the relevant ui elements closer together
# if there is a chain of containers, pick the most nested one

extends TabContainer
@onready var things = %things
@onready var settings = %settings
@onready var achievements = %achievements

const BACKUPDIRECTORY = "user://backup.save" # debug
const SAVEDIRECTORY = "user://savegame.save"
const TEMPSAVEDIRECTORY = "user://tempsavegame.save"
const THINGSCONT = preload("res://game/thingsCont.tscn")
const CYYAN = preload("res://game/cyyan/cyyan.tscn")
const TEXTPOPUP = preload("res://assets/ui/textPopup.tscn")
const SAVEPOPUP = preload("res://assets/ui/savePopup.tscn")
enum UNLOCK {NONE, CYYAN}
const NODEPATHS = {
	game = "/root/game",
	
	# things = "/root/game/thingsCont/things",
	# generators = "/root/game/thingsCont/things/cont/cont/main/topside/generators",
	# clicks = "/root/game/thingsCont/things/cont/cont/main/topside/clicks",
	# funnyUpgs = "/root/game/thingsCont/things/cont/cont/main/main/margins/funnyUpgs",
	
	cyyan = "/root/game/thingsCont/cyyan",
	milestones = "/root/game/thingsCont/cyyan/cont/cont/topside/margins/milestones",
	choices = "/root/game/thingsCont/cyyan/cont/cont/main/margins/choices",
	
	settings = "/root/game/settings",
	formatting = "/root/game/settings/cont/cont/formatting",
	saving = "/root/game/settings/cont/cont/topside/cont/main/saving",
	uiScaling = "/root/game/settings/cont/cont/topside/cont/main/main/uiScaling",
	
	achievements = "/root/game/achievements",
}
# do this please

@onready var timePlayed = Dec.D(0)
var timeSaved = 0.0
var cyyanUnlocked = false
# computed
var timeSinceSave = 0.0
var thingsCont
var cyyan
var impatientSaveCount = 0.0
var savePopup
var autosaveOverride = true
var paused = false

func _ready():
	update()
	savePopup = SAVEPOPUP.instantiate().set_data(getSaveMetadata().timePlayed)
	if FileAccess.file_exists(SAVEDIRECTORY): $"/root".add_child.call_deferred(savePopup)
	

func _process(delta):

	# here is the main processing of the game
	# all things that happen by procedure in a frame should go here
	# autosaving
	timeSinceSave += delta
	if timeSinceSave > settings.saving.autosaveInterval and settings.saving.autosaveInterval != 0 and !autosaveOverride:
		initiateSave(true)
	impatientSaveCount -= 2*delta
	impatientSaveCount = max(impatientSaveCount,0)
	
	# PROCESSING
	if !paused:
		timePlayed.Incr(delta)
		things.clicks.procTimeSinceClick(delta)
		if cyyanUnlocked: cyyan.procCyyan()
		things.generators.procGens()
		things.procTPS(delta)
		things.clicks.procThingsPerClick()
		things.clicks.procClicksPerClick()
	
	# UPDATE VISUALS
	# make sure the right tabs are disabled; make sure tabs are named correctly
	updateTabs()
	# update button disabling
	things.updateButtons()
	if cyyanUnlocked: cyyan.updateButtons()
	# update the text on everything
	things.updateText()
	if cyyanUnlocked: cyyan.updateText()
	achievements.updateText()
	settings.updateText()
	get_tree().call_group("hover", "updateText")

func updateTabs(unlock:=UNLOCK.NONE):
	if unlock == UNLOCK.CYYAN: cyyanUnlocked = true
	set_tab_title(0, "Things")
	set_tab_title(1, "Achievements")
	set_tab_title(2, "Settings")
	set_tab_title(3, "Information")
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
		thingsCont.set_tab_title(0, "Basic: " + things.things.F())
		thingsCont.set_tab_title(1, "Cyyan: " + cyyan.cyyan.F())

func initiateSave(autosaved:=false, toClipboard:=false):
	if timeSinceSave < 0.5: 
		impatientSaveCount += 1
		if impatientSaveCount >= 10: achievements.unlockAch("secret", 3)
	timeSinceSave = 0
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
		save_file.store_line(JSON.stringify(cyyan.choices.save()))
	
	save_file.store_line(JSON.stringify(settings.save()))
	save_file.store_line(JSON.stringify(settings.formatting.save()))
	save_file.store_line(JSON.stringify(settings.saving.save()))
	save_file.store_line(JSON.stringify(settings.scaling.save()))
	
	save_file.store_line(JSON.stringify(achievements.save()))
	if toClipboard:
		save_file.close()
		save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.READ)
		DisplayServer.clipboard_set(save_file.get_as_text())
	$"/root".add_child.call_deferred(TEXTPOPUP.instantiate().set_data("Autosaved" if autosaved else "Saved"))

func getSaveMetadata():
	assert(FileAccess.file_exists(SAVEDIRECTORY))
	var save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var check = json.parse(json_string)
	# [Check if there is any error while parsing the JSON string, skip in case of failure]
	if !(check == OK):
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		$"/root".add_child.call_deferred(TEXTPOPUP.instantiate().set_data("please send save file; JSON Parse Error: " + json.get_error_message() + " in save file at line " + str(json.get_error_line())))
		return
	
	var node_data = json.get_data()
	var toReturn = node_data
	
	for key in node_data:
		if typeof(node_data[key]) == TYPE_ARRAY and node_data[key][0] == "Decimal":
			toReturn[key] = Dec.fromArray(node_data[key])
	
	return toReturn

func initiateLoad(fromClipboard:=false, fromBackup:=false):
	paused = true
	if not FileAccess.file_exists(SAVEDIRECTORY):
		$"/root".add_child.call_deferred(TEXTPOPUP.instantiate().set_data("There is no save file"))
		paused = false
		return
	
	var save_file : FileAccess
	if fromClipboard:
		save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.WRITE)
		save_file.store_string(DisplayServer.clipboard_get())
		save_file.close()
		save_file = FileAccess.open(TEMPSAVEDIRECTORY, FileAccess.READ)
	elif fromBackup: save_file = FileAccess.open(BACKUPDIRECTORY, FileAccess.READ)
	else: save_file = FileAccess.open(SAVEDIRECTORY, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# [Creates the helper class to interact with JSON]
		var json = JSON.new()
		
		# so json.parse sets json to the parsed of json_string. i see
		var check = json.parse(json_string)
		# [Check if there is any error while parsing the JSON string, skip in case of failure]
		if !(check == OK):
			push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			$"/root".add_child.call_deferred(TEXTPOPUP.instantiate().set_data("please send save file; JSON Parse Error: " + json.get_error_message() + " in save file at line " + str(json.get_error_line())))
			paused = false
			return
		
		var node_data = json.get_data()
		var node_path
		if "nodepath" in node_data.keys(): node_path = node_data["nodepath"]
		else: node_path = NODEPATHS[node_data["node"]]
		
		for variable in node_data.keys():
			if variable != "nodepath":
				var currentVar = node_data[variable]
				if typeof(currentVar) == TYPE_ARRAY and currentVar[0] == "Decimal": get_node(node_path).set(variable, Dec.fromArray(currentVar))
				elif typeof(currentVar) == TYPE_DICTIONARY: # extendable dictionary arrays; just for achievements basically
					var toset = get_node(node_path).get(variable)
					for key in currentVar.keys():
						if typeof(currentVar[key]) == TYPE_ARRAY:
							for i in range(len(currentVar[key])):
								toset[key][i] = currentVar[key][i]
					get_node(node_path).set(variable, toset)
				else: get_node(node_path).set(variable, currentVar)
		if node_path == "/root/game": updateTabs()
	update()
	paused = false
	$"/root".add_child.call_deferred(TEXTPOPUP.instantiate().set_data("Loaded"))

func update(): # for one time updates; this is an "update all"
	things.funnyUpgs.update()
	if cyyanUnlocked:
		cyyan.milestones.update()
		cyyan.choices.update()
	achievements.update()
	settings.setFromData()

func save():
	return {
		"node" : self.name,
		"timePlayed" : timePlayed.asArray(),
		"timeSaved" : timeSaved,
		"cyyanUnlocked" : cyyanUnlocked
	}
