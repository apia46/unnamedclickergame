extends VBoxContainer
@onready var game = $"/root/game"
@onready var things = $"../../../../.." # has to be relative (/things moves)

@onready var clicks = Dec.D(0)
@onready var timeSinceClick = Dec.D(0)

@onready var perClickUpg = Dec.D(0)
@onready var perClickUpgPer = Dec.D(1)
@onready var perClickUpgCost = Dec.D(1) # cost in things
var clicksMod12 : int = 0
# computed
@onready var thingsPerClick = Dec.D(1)
@onready var funnyUpg2 = Dec.D(1)
@onready var funnyUpg6 = Dec.D(1)
@onready var perClickUpgEffect = Dec.D(0)
@onready var effectivePerClickUpgPer = Dec.D(1)
@onready var funnyUpg12 = Dec.D(0)

@onready var clicksPerClick = Dec.D(1) # help
@onready var active2 = Dec.D(1)
@onready var timing2 = Dec.D(1)
@onready var milestone3 = Dec.D(1)
@onready var passive4 = Dec.D(1)

@onready var funny2Cap = Dec.D(3)
@onready var active4 = Dec.D(0)

func _ready(): pass

func procThingsPerClick():
	thingsPerClick = Dec.D(1)
	funnyUpg2 = Dec.D(1)
	funnyUpg6 = Dec.D(1)
	perClickUpgEffect = Dec.D(0)
	effectivePerClickUpgPer = Dec.D(1)
	funnyUpg12 = Dec.D(0)
	funny2Cap = Dec.D(3)
	
	milestone3 = Dec.D(1)
	passive4 = Dec.D(1)
	
	perClickUpgEffect = perClickUpg
	if things.funnyUpgs.stage > 12: funnyUpg12 = Dec.D(things.funnyUpgs.stage).Mul(0.05)
	if things.funnyUpgs.stage > 9:
		perClickUpgEffect = perClickUpg.PowOf(Dec.D(2).Add(funnyUpg12))
		effectivePerClickUpgPer = perClickUpg.Add(perClickUpgPer).PowOf(Dec.D(2).Add(funnyUpg12)).Minus(perClickUpgEffect)
	thingsPerClick.Incr(perClickUpgEffect)
	
	if things.funnyUpgs.stage > 2:
		if game.cyyanUnlocked and game.cyyan.choices.active3: timeSinceClick.Incr(1)
		# reasonable tbh
		if game.cyyanUnlocked and game.cyyan.choices.timing4: funny2Cap = Dec.D(300)
		if timeSinceClick.LessThan(funny2Cap): funnyUpg2 = timeSinceClick.Squared().Mul(4).Add(1)
		else: funnyUpg2 = funny2Cap.Squared().Mul(4).Add(timeSinceClick.Mul(3)).Minus(funny2Cap.Mul(3)).Add(funny2Cap.Minus(timeSinceClick).Minus(0.2).Rc()).Add(6)
		
		if things.game.cyyanUnlocked and things.game.cyyan.milestones.stage > 3: milestone3 = Dec.D(1.6)
		if game.cyyanUnlocked and game.cyyan.choices.passive3: milestone3.Incr(0.1)
		funnyUpg2.PowOfr(milestone3)
		thingsPerClick.Mulr(funnyUpg2)
		if game.cyyanUnlocked and game.cyyan.choices.active3: timeSinceClick.Decr(1)
	
	if things.funnyUpgs.stage > 6:
		funnyUpg6 = things.things.Add(1).Ln()
		thingsPerClick.Mulr(funnyUpg6)
	if game.cyyanUnlocked and game.cyyan.choices.active4: thingsPerClick.PowOfr(active4.Add(1))

func procClicksPerClick():
	# fuck this lmao??
	clicksPerClick = Dec.D(1)
	active2 = Dec.D(1)
	timing2 = Dec.D(1)
	
	assert(clicks.LessThan(9223372036854775807))
	if game.cyyanUnlocked and game.cyyan.choices.active1:
		if clicksMod12 % 2 == 0: clicksPerClick.Mulr(22)
		if clicksMod12 % 3 == 0: clicksPerClick.Mulr(3)
		if clicksMod12 % 4 == 0: clicksPerClick.Mulr(4)
	
	active2 = timeSinceClick.Div(3).Add(0.005).Rc().Mul(4).Add(1)
	if game.cyyanUnlocked and game.cyyan.choices.active2: clicksPerClick.Mulr(active2)
	timing2 = timeSinceClick.Add(1.5).Ln().Add(2).PowOf(1.4)
	if game.cyyanUnlocked and game.cyyan.choices.timing2: clicksPerClick.Mulr(timing2)

func procTimeSinceClick(delta):
	var deltaEffect = Dec.D(delta)
	if game.cyyanUnlocked and game.cyyan.choices.passive1: deltaEffect.Mulr(4)
	passive4 = timeSinceClick.Add(2.8).Ln().PowOf(2)
	if game.cyyanUnlocked and game.cyyan.choices.passive4: deltaEffect.Mulr(passive4)
	timeSinceClick.Incr(deltaEffect)
	active4.Decr(Dec.D(0.3).Mul(delta))
	active4 = Dec.Decimal.Max(active4, 0)

func _clicked():
	things.addThings(thingsPerClick.Mul(clicksPerClick))
	clicks.Incr(clicksPerClick)
	if game.cyyanUnlocked and game.cyyan.choices.active3: timeSinceClick = Dec.D(1)
	else: timeSinceClick = Dec.D(0)
	# active1
	clicksMod12 += 1
	clicksMod12 %= 12
	
	active4.Incr(0.05)
	active4 = Dec.Decimal.Min(active4, 0.6)

func _upg_buy():
	things.costThings(perClickUpgCost)
	perClickUpgCost.Mulr(perClickUpg.Add(2)) # factorial
	perClickUpg.Incr(1)

func updateButtons():
	$"perClickUpgButton".disabled = things.things.LessThan(perClickUpgCost)

func updateText():
	$"thingButton".text = "Thing Button
+"+thingsPerClick.F("thing", !things.funnyUpgs.stage > 2)+("\nx" + clicksPerClick.F() if clicksPerClick.GreaterThan(1) else "")
	$"perClickUpgButton".text = "More things per click
+"+effectivePerClickUpgPer.F("",true)+" costs "+perClickUpgCost.F("thing", true)+"
Currently +"+perClickUpgEffect.F("",true)

func save():
	return {
		"node" : self.name,
		"nodepath" : self.get_path(),
		"clicks" : clicks.asArray(),
		"timeSinceClick" : timeSinceClick.asArray(),
		
		"perClickUpg" : perClickUpg.asArray(),
		"perClickUpgPer" : perClickUpgPer.asArray(),
		"perClickUpgCost" : perClickUpgCost.asArray(),
		
		"clicksMod12" : clicksMod12,
	}
