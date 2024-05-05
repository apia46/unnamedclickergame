extends PanelContainer

func set_data(playtime):
	$"margins/cont/topLabel".text = "[center]You have a save file with
"+playtime.FT(true)+" of playtime
Would you like to load it?[/center]"
	return self

func _do():
	$"/root/game".autosaveOverride = false
	$"/root/game".initiateLoad()
	queue_free()

func _doNot():
	$"/root/game".autosaveOverride = false
	queue_free()
