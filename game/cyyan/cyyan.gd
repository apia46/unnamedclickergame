extends MarginContainer
@onready var game = $"/root/game"
@onready var milestones = $"cont/cont/topside/margins/milestones"

@onready var cyyan = Dec.D(1)
# computed
@onready var thingsPerCyyan = Dec.D(1e6)
@onready var cyyanPerSecond = Dec.D(0)

func _ready(): pass # likely just pass

func addCyyanFromThings(amount):
	cyyan.Incr(amount.Div(thingsPerCyyan))

func procCyyan():
	cyyanPerSecond = game.things.TPS.Div(thingsPerCyyan)


# _listeners here

func updateButtons():
	milestones.updateButtons()

func updateText():
	$"cont/cont/textCont/cyyanLabel".text = "You have "+cyyan.F("cyyan thing")
	$"cont/cont/textCont/cyyanPerSecondLabel".text = "You are gaining "+cyyanPerSecond.F("cyyan thing")+" per second"
	var until = thingsPerCyyan.Mul(1-fmod(cyyan.ToFloat(),1))
	$"cont/cont/textCont/perLabel".text = "+1 cyyan thing per "+thingsPerCyyan.F("thing",true)+" you get"+(", "+until.F()+" until next" if cyyan.LessThan(1e16) else "")
	
	milestones.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"cyyan" : cyyan.asArray(),
	}
