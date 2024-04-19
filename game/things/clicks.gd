extends VBoxContainer
@onready var things = $"../../../.." # has to be relative (/things moves)

@onready var clicks = Dec.D(0)
@onready var timeSinceClick = Dec.D(0)

@onready var perClickUpg = Dec.D(0)
@onready var perClickUpgPer = Dec.D(1)
@onready var perClickUpgCost = Dec.D(1) # cost in things
# computed
@onready var thingsPerClick = Dec.D(1)
@onready var funnyUpg2 = Dec.D(1)
@onready var funnyUpg6 = Dec.D(1)
@onready var perClickUpgEffect = Dec.D(0)
@onready var effectivePerClickUpgPer = Dec.D(1)
@onready var funnyUpg14 = Dec.D(0)

func _ready(): pass

func procThingsPerClick():
	thingsPerClick = Dec.D(1)
	perClickUpgEffect = perClickUpg
	if things.funnyUpgs.stage > 14: funnyUpg14 = Dec.D(things.funnyUpgs.stage).Mul(0.05)
	if things.funnyUpgs.stage > 9:
		perClickUpgEffect = perClickUpg.PowOf(Dec.D(2).Add(funnyUpg14))
		effectivePerClickUpgPer = perClickUpg.Add(perClickUpgPer).PowOf(Dec.D(2).Add(funnyUpg14)).Minus(perClickUpgEffect)
	thingsPerClick.Incr(perClickUpgEffect)
	
	if things.funnyUpgs.stage > 2:
		funnyUpg2 = Dec.D(1)
		if timeSinceClick.LessThan(3): funnyUpg2 = timeSinceClick.Squared().Mul(4).Add(1)
		else:
			funnyUpg2 = timeSinceClick.Mul(3).Add(timeSinceClick.Neg().Add(2.8).Reciprocal()).Add(33)
		if things.game.cyyanUnlocked and things.game.cyyan.milestones.stage > 3: funnyUpg2 = funnyUpg2.PowOf(1.5)
		thingsPerClick.Mulr(funnyUpg2)
	
	if things.funnyUpgs.stage > 6:
		funnyUpg6 = things.things.Add(1).Ln()
		thingsPerClick.Mulr(funnyUpg6)

func procTimeSinceClick(delta):
	timeSinceClick.Incr(delta)

func _clicked():
	things.addThings(thingsPerClick)
	clicks.Incr(1)
	timeSinceClick = Dec.D(0)

func _upg_buy():
	things.costThings(perClickUpgCost)
	perClickUpgCost.Mulr(perClickUpg.Add(2)) # factorial
	perClickUpg.Incr(1)

func updateButtons():
	$"perClickUpgButton".disabled = things.things.LessThan(perClickUpgCost)

func updateText():
	$"thingButton".text = "Thing Button
+"+thingsPerClick.F("thing")
	$"perClickUpgButton".text = "More things per click
+"+effectivePerClickUpgPer.F()+" costs "+perClickUpgCost.F("thing")+"
Currently +"+perClickUpgEffect.F()

func save():
	return {
		"nodepath" : self.get_path(),
		"clicks" : clicks.asArray(),
		"timeSinceClick": timeSinceClick.asArray(),
		
		"perClickUpg": perClickUpg.asArray(),
		"perClickUpgPer": perClickUpgPer.asArray(),
		"perClickUpgCost": perClickUpgCost.asArray(),
	}
