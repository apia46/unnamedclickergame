extends MarginContainer
@onready var game = $"/root/game"
@onready var milestones = $"cont/cont/topside/margins/milestones"
@onready var choices = $"cont/cont/main/margins/choices"

@onready var cyyan = Dec.D(1)
@onready var cyyantotal = Dec.D(1)
# computed
@onready var thingsPerCyyan = Dec.D(1e6)
@onready var cyyanPerSecond = Dec.D(0)

func _ready(): pass # likely just pass

func addCyyanFromThings(amount):
	cyyan.Incr(amount.Div(thingsPerCyyan))
	cyyantotal.Incr(amount.Div(thingsPerCyyan))

func costCyyan(amount):
	cyyan.Decr(amount)

func procCyyan():
	thingsPerCyyan = Dec.D(1e6)
	cyyanPerSecond = game.things.TPS.Div(thingsPerCyyan)


# _listeners here

func updateButtons():
	milestones.updateButtons()
	choices.updateButtons()

func updateText():
	$"cont/cont/textCont/cyyanLabel".text = "You have "+cyyan.F("cyyan thing")
	$"cont/cont/textCont/cyyanPerSecondLabel".text = "You are gaining "+cyyanPerSecond.F("cyyan thing")+" per second"
	var until = thingsPerCyyan.Mul(1-fmod(cyyan.ToFloat(),1))
	$"cont/cont/textCont/perLabel".text = "+1 cyyan thing per "+thingsPerCyyan.F("thing",true)+" you get"+(", "+until.F()+" until next" if cyyanPerSecond.LessThan(10) else "")
	
	milestones.updateText()
	choices.updateText()

func save():
	return {
		"node" : self.name,
		"cyyan" : cyyan.asArray(),
	}
