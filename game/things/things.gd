extends MarginContainer
@onready var clicks = $cont/cont/main/topside/clicks
@onready var generators = $cont/cont/main/topside/generators
@onready var funnyUpgs = $cont/cont/main/main/margins/funnyUpgs
@onready var game = $"/root/game"
@onready var achievements = $"/root/game/achievements"

@onready var things = Dec.D(0)
@onready var thingsTotal = Dec.D(0)
# computed
@onready var TPS = Dec.D(0)
@onready var gensOutput = Dec.D(0)

@onready var milestone1 = Dec.D(1)
@onready var funnyUpg11 = Dec.D(0)

func _ready(): pass

func addThings(amount:Dec.Decimal):
	if amount.GE(1): achievements.unlockAch("basic",0)
	things.Incr(amount)
	if things.GE(1e6): achievements.unlockAch("basic",6)
	thingsTotal.Incr(amount)
	if game.cyyanUnlocked: game.cyyan.addCyyanFromThings(amount)

func costThings(amount):
	things.Decr(amount)

# processes things per second
func procTPS(delta):
	gensOutput = Dec.D(0)
	gensOutput = generators.gensTotal.Mul(generators.tpsPerGen)
	
	TPS = Dec.D(0)
	TPS.Incr(gensOutput)
	if funnyUpgs.stage > 11: funnyUpg11 = generators.genMult.Mul(0.01)
	if funnyUpgs.stage > 4: gensOutput.PowOfr(Dec.D(1.1).Add(funnyUpg11))
	if game.cyyanUnlocked and game.cyyan.milestones.stage > 1:
		if game.cyyan.cyyan.Floor().PowOf(0.7).Add(1).LessThan(2e8):
			milestone1 = game.cyyan.cyyan.Floor().PowOf(0.7).Add(1)
		else:
			milestone1 = game.cyyan.cyyan.Minus(6e11).Ln().PowOf(4).Mul(5e2)
	TPS.Mulr(milestone1)
	
	addThings(TPS.Mul(delta))

func updateButtons():
	clicks.updateButtons()
	generators.updateButtons()
	funnyUpgs.updateButtons()

func updateText():
	$"cont/cont/textCont/thingsLabel".text = "You have "+things.F("thing", gensOutput.Eq(0))
	$"cont/cont/textCont/tpsLabel".text = "You are gaining "+TPS.F("thing", !funnyUpgs.stage > 13)+" per second (TPS)"
	
	clicks.updateText()
	generators.updateText()
	funnyUpgs.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"things" : things.asArray(),
		"thingsTotal": thingsTotal.asArray(),
	}
