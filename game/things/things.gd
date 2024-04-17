extends MarginContainer
@onready var clicks = $cont/main/topside/clicks
@onready var generators = $cont/main/topside/generators
@onready var funnyUpgs = $cont/main/main/margins/funnyUpgs

@onready var things = Dec.D(0)
@onready var thingsTotal = Dec.D(0)
# computed
@onready var TPS = Dec.D(0)

func _ready(): pass

func addThings(amount:Dec.Decimal):
	things.Incr(amount)
	thingsTotal.Incr(amount)

func costThings(amount:Dec.Decimal):
	things.Decr(amount)

# processes things per second
func procTPS(delta):
	TPS = Dec.D(0) # base
	TPS.Incr(generators.gens.Mul(generators.tpsPerGen))
	
	addThings(TPS.Mul(delta))

func updateButtons():
	clicks.updateButtons()
	generators.updateButtons()
	funnyUpgs.updateButtons()

func updateText():
	$"cont/textCont/thingsLabel".text = "You have "+things.F("thing")
	$"cont/textCont/tpsLabel".text = "You are gaining "+TPS.F("thing")+" per second"
	
	clicks.updateText()
	generators.updateText()
	funnyUpgs.updateText()
