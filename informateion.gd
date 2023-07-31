extends Control
@onready var things = get_node("/root/game/tabs/things/normal")
@onready var cyyan = get_node("/root/game/tabs/things/cyyan")
@onready var magenter = get_node("/root/game/tabs/things/magenter")
@onready var format = get_node("/root/game").format
@onready var game = get_node("/root/game")
var timestarted = Time.get_unix_time_from_system()


func _update_per_frame():
	%informat.text = ("you have made a total of " + format.number(things.thingsalltime) + " things") + (("
	and a total of " + format.number(cyyan.cyyanthingsalltime) + " cyyan things") if (things.cyyanmechanic) else "") + (("
	and a total of " + format.number(magenter.magenterthingsalltime) + " magenter things") if (cyyan.magentermechanic) else "") + ("
	you have spent " + format.time(int(game.time)) + " on this shitsterpiece") + ("
	and you started playing " + format.time(int(Time.get_unix_time_from_system()-timestarted)) + " ago")


func save():
	var save_dict = {
		"nodepath" : self.get_path(),
		"timestarted" : timestarted,
	}
	return save_dict
