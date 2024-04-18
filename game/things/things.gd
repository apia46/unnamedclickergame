extends MarginContainer
@onready var clicks = $cont/main/topside/clicks
@onready var generators = $cont/main/topside/generators
@onready var funnyUpgs = $cont/main/main/margins/funnyUpgs

@onready var things = Dec.D(0)
@onready var thingsTotal = Dec.D(0)
# computed
@onready var TPS = Dec.D(0)
@onready var gensOutput = Dec.D(0)

func _ready(): pass

func addThings(amount):
	things.Incr(amount)
	thingsTotal.Incr(amount)

func costThings(amount):
	things.Decr(amount)

# processes things per second
func procTPS(delta):
	gensOutput = Dec.D(0)
	gensOutput = generators.gens.Mul(generators.tpsPerGen)
	if funnyUpgs.stage > 4: gensOutput.PowOfr(1.1)
	
	TPS = Dec.D(0)
	TPS.Incr(gensOutput)
	
	addThings(TPS.Mul(delta))

func updateButtons():
	clicks.updateButtons()
	generators.updateButtons()
	funnyUpgs.updateButtons()

func updateText():
	$"cont/textCont/thingsLabel".text = "You have "+things.F("thing")
	$"cont/textCont/tpsLabel".text = "You are gaining "+TPS.F("thing")+" per second (TPS)"
	
	clicks.updateText()
	generators.updateText()
	funnyUpgs.updateText()

func save():
	return {
		"nodepath" : self.get_path(),
		"things" : things.asArray(),
		"thingsTotal": thingsTotal.asArray(),
	}
