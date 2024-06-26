extends VBoxContainer
@onready var game = $"/root/game"
@onready var things = $"../../../../.." # has to be relative (/things moves)

@onready var gens = Dec.D(0)
@onready var gensPer = Dec.D(1)
@onready var gensCost = Dec.D(200) # cost in things; computed

@onready var genMult = Dec.D(0)
@onready var genMultPer = Dec.D(1)
@onready var genMultCost = Dec.D(5) # cost in gens; computed
# computed
@onready var genMultiplier = Dec.D(1)
@onready var tpsPerGen = Dec.D(1)

@onready var bonusGens = Dec.D(0)
@onready var untilNextBonus = Dec.D(0)
@onready var gensTotal = Dec.D(0)

@onready var funnyUpg13 = Dec.D(0)
@onready var baseBonusGens = Dec.D(0)
@onready var funnyUpg15 = Dec.D(1)
@onready var gensScaling = Dec.D(1.2)

func _ready(): pass

func addGens(amount):
	gens.Incr(amount)

func costGens(amount):
	gens.Decr(amount)

func procGens():
	genMultiplier = Dec.D(1)
	tpsPerGen = Dec.D(1)
	bonusGens = Dec.D(0)
	untilNextBonus = Dec.D(0)
	gensTotal = Dec.D(0)
	funnyUpg13 = Dec.D(0)
	baseBonusGens = Dec.D(0)
	funnyUpg15 = Dec.D(1)
	gensScaling = Dec.D(1.2)
	
	if things.funnyUpgs.stage > 15: funnyUpg15 = Dec.Decimal.Max(1, things.clicks.thingsPerClick.Add(1).Ln().PowOf(0.7))
	if things.funnyUpgs.stage > 8:
		baseBonusGens = things.thingsTotal.Log2().Floor()
		untilNextBonus = Dec.Decimal.Pow(2,baseBonusGens.Add(1)).Minus(things.thingsTotal)
	bonusGens = baseBonusGens.Mul(funnyUpg15)
	gensTotal = gens.Add(bonusGens)
	
	if game.cyyanUnlocked and game.cyyan.milestones.stage > 7: gensScaling = Dec.D(1.1)
	gensCost = Dec.D(200).Mul(gensScaling.PowOf(gens.Div(gensPer)))
	
	genMultCost = Dec.D(5).PowOf(Dec.D(1.15).PowOf(genMult.Add(1))).Floor()
	
	genMultiplier.Incr(genMult)
	
	if things.funnyUpgs.stage > 13: funnyUpg13 = Dec.Decimal.Max(things.game.cyyan.cyyan.Floor().Ln().Ln(), 0)
	gensPer = Dec.D(1)
	if things.funnyUpgs.stage > 1: gensPer.Mulr(Dec.D(2).Add(funnyUpg13))
	
	tpsPerGen.Mulr(genMultiplier)

func _gens_buy():
	things.costThings(gensCost)
	addGens(gensPer)

func _genMult_buy():
	costGens(genMultCost.Minus(bonusGens))
	genMult.Incr(genMultPer)

func updateButtons():
	$"gensButton".disabled = things.things.LessThan(gensCost)
	$"genMultButton".disabled = gensTotal.LessThan(genMultCost)

func updateText():
	var bonusText = " + "+bonusGens.F("bonus",!things.funnyUpgs.stage > 15) + " = " + gensTotal.F("",!things.funnyUpgs.stage > 15)
	$"gensButton".text = "Thing Generators
+"+gensPer.F("",!things.funnyUpgs.stage > 13)+" costs "+gensCost.F("thing", !things.funnyUpgs.stage > 13)+"
Currently "+gens.F("generator",true)+(bonusText if things.funnyUpgs.stage > 8 else "")+"
"+("each " if gens.Plural() else "")+"producing "+(things.gensOutput.Div(gens) if gens.GreaterThan(0) else tpsPerGen).F("thing",!things.funnyUpgs.stage > 15)+" per second"
	$"genMultButton".text = "Thing Generator Multiplier
+"+genMultPer.F("", true)+"x costs "+genMultCost.F("thing generator", true)+"
Currently +"+genMult.F("", true)+"x"

func save():
	return {
		"node" : self.name,
		"nodepath" : self.get_path(),
		"gens" : gens.asArray(),
		"gensPer": gensPer.asArray(),
		
		"genMult": genMult.asArray(),
		"genMultPer": genMultPer.asArray(),
	}
