extends MarginContainer
@onready var reference # references to other nodes
const ACHIEVEMENT = preload("res://game/achievements/achievement.tscn")
const POPUP = preload("res://game/achievements/achievementPopup.tscn")

var achs = {
	"basic": [false],
}
# computed
var achObjs = {
	"basic": []
}

func _ready(): pass # likely just pass

func unlockAch(category, ach):
	if achs[category][ach]: return
	var achiev = achObjs[category][ach]
	achiev.unlocked = true
	achs[category][ach] = true
	$"/root".add_child.call_deferred(POPUP.instantiate().set_data(achiev.unlockedImg, achiev.title, achiev.desc))
	updateAchs()

# _listeners here

func updateAchs(): pass

func update():
	for category in achObjs: for ach in achObjs[category]: ach.queue_free()
	for category in achs:
		achObjs[category] = []
		for i in range(len(achs[category])):
			achObjs[category].append(ACHIEVEMENT.instantiate().set_data(category + str(i), achs[category][i]))
			var ach = achObjs[category][i]
			match category:
				"basic": $"cont/cont/basicAchievements".add(ach)
	updateAchs()

func updateText():
	$"cont/cont/basicAchievements".updateText("Basic Achievements ("+str(achs.basic.count(true))+"/"+str(len(achs.basic))+")")
	for category in achObjs: for ach in achObjs[category]: ach.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"achs" : achs,
	}

