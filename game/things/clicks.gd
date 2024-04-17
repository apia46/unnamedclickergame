extends VBoxContainer
@onready var things = $"../../../.." # has to be relative (/things moves)

@onready var clicks = Dec.D(0)

@onready var perClickUpg = Dec.D(0)
@onready var perClickUpgPer = Dec.D(1)
@onready var perClickUpgCost = Dec.D(1) # cost in things
# computed
@onready var thingsPerClick = Dec.D(1)

func _ready(): pass

func procThingsPerClick():
	thingsPerClick = Dec.D(1) # base
	thingsPerClick.Incr(perClickUpg)

func _clicked():
	things.addThings(thingsPerClick)
	clicks.Incr(1)

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
+"+perClickUpgPer.F()+" costs "+perClickUpgCost.F("thing")+"
Currently +"+perClickUpg.F()
