extends MarginContainer
@onready var achConts = {
	"basic": $"cont/cont/basicAchievements",
	"cyyan": $"cont/cont/cyyanAchievements",
	"secret": $"cont/cont/secretAchievements",
}
const ACHIEVEMENT = preload("res://game/achievements/achievement.tscn")
const POPUP = preload("res://game/achievements/achievementPopup.tscn")

var achs = {
	"basic": [false, false, false, false, false, false, false],
	"cyyan": [false, false, false, false],
	"secret": [false, false, false, false],
}
# computed
var achObjs = {
	"basic": [],
	"cyyan": [],
	"secret": [],
}
var unlocked = {
	"basic": true,
	"cyyan": false,
	"secret": true,
}
var achCounts = {}

var achCount = 0
var totalAchCount = 0

func _ready(): pass

func unlockAch(category, ach):
	if achs[category][ach]: return
	var achiev = achObjs[category][ach]
	achiev.unlocked = true
	achs[category][ach] = true
	$"/root".add_child.call_deferred(POPUP.instantiate().set_data(achiev.unlockedImg, achiev.title, achiev.desc))
	updateAchs()

# _listeners here

func updateAchs():
	achCount = 0
	totalAchCount = 0
	for category in achs:
		if category != "secret":
			var count = achs[category].count(true)
			if count > 0: unlocked[category] = true
			achCount += count
			achCounts[category] = count
			totalAchCount += len(achs[category])

func update():
	for category in achObjs: for ach in achObjs[category]: ach.queue_free()
	for category in achs:
		achObjs[category] = []
		for i in range(len(achs[category])):
			achObjs[category].append(ACHIEVEMENT.instantiate().set_data(category + str(i), achs[category][i]))
			var ach = achObjs[category][i]
			achConts[category].add(ach)
	updateAchs()

func updateText():
	for category in achObjs:
		if category != "secret":
			if unlocked[category]: achConts[category].updateText(category[0].to_upper() + category.substr(1,-1)+" Achievements ("+Dec.D(achCounts[category]).F("", true)+"/"+Dec.D(len(achs[category])).F("", true)+")")
			achConts[category].visible = unlocked[category]
	$"cont/cont/secretAchievements".updateText("Total: "+Dec.D(achCount).F("", true)+"/"+Dec.D(totalAchCount).F("", true))
	for category in achObjs: for ach in achObjs[category]: ach.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"achs" : achs,
	}

