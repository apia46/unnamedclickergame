extends VBoxContainer
@onready var things = $"../../../.." # has to be relative (/things moves)

@onready var gens = Dec.D(0)
@onready var gensPer = Dec.D(1)
@onready var gensCost = Dec.D(200) # cost in things; computed

@onready var genMult = Dec.D(0)
@onready var genMultPer = Dec.D(1)
@onready var genMultCost = Dec.D(5) # cost in gens; computed
# computed
@onready var genMultiplier = Dec.D(1)
@onready var tpsPerGen = Dec.D(1)

func _ready(): pass

func addGens(amount):
	gens.Incr(amount)

func costGens(amount):
	gens.Decr(amount)

func procGens():
	gensCost = Dec.D(200).Mul(Dec.D(1.2).PowOf(gens.Div(gensPer)))
	
	genMultiplier = Dec.D(1)
	genMultiplier.Incr(genMult)
	
	gensPer = Dec.D(1)
	if things.funnyUpgs.stage > 1: gensPer.Mulr(2)
	
	tpsPerGen = Dec.D(1)
	tpsPerGen.Mulr(genMultiplier)

func _gens_buy():
	things.costThings(gensCost)
	addGens(gensPer)

func _genMult_buy():
	costGens(genMultCost)
	genMultCost = Dec.D(5).PowOf(Dec.D(1.15).PowOf(genMult.Add(1))).Floor()
	genMult.Incr(genMultPer)

func updateButtons():
	$"gensButton".disabled = things.things.LessThan(gensCost)
	$"genMultButton".disabled = gens.LessThan(genMultCost)

func updateText():
	$"gensButton".text = "Thing Generators
+"+gensPer.F()+" costs "+gensCost.F("thing")+"
Currently "+gens.F("generator")+"
"+("each " if gens.Plural() else "")+"producing "+(things.gensOutput.Div(gens) if gens.GreaterThan(0) else tpsPerGen).F("thing")+" per second"
	$"genMultButton".text = "Thing Generator Multiplier
+"+genMultPer.F()+"x costs "+genMultCost.F("thing generator")+"
Currently +"+genMult.F()+"x"

func save():
	return {
		"nodepath" : self.get_path(),
		"gens" : gens.asArray(),
		"gensPer": gensPer.asArray(),
		
		"genMult": genMult.asArray(),
		"genMultPer": genMultPer.asArray(),
	}
