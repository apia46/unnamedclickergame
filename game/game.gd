# Structure notes:

# variables/code/listeners should belong to the node they are most relevant to, there should usually be a container general enough but not too general for this purpose
# if there isnt, maybe it would be best to put the relevant ui elements closer together
# if there is a chain of containers, pick the most nested one

extends TabContainer
@onready var things = %things
@onready var settings = %settings


func _ready(): update()

func _process(delta):
	# here is the main processing of the game
	# all things that happen by procedure in a frame should go here
	
	# PROCESSING
	things.clicks.procTimeSinceClick(delta)
	things.generators.procGens()
	things.procTPS(delta)
	things.clicks.procThingsPerClick()
	
	# UPDATE VISUALS
	# update button disabling
	things.updateButtons()
	# update the text on everything
	things.updateText()
	settings.updateText()
	
	# make sure the right tabs are disabled; make sure tabs are named correctly
	updateTabs()

func updateTabs():
	set_tab_title(0, "Things")
	set_tab_title(1, "Settings")

func update(): # for one time updates; this is an "update all"
	things.funnyUpgs.update()
	for i in range(-100, 0):
		print(Format.formatDecimalStandard(Dec.ME(1, i), 2, Format.AFFIX_LENS.SHORT, Dec.seperator, Dec.decimalPoint))
		print(Format.formatDecimalStandard(Dec.ME(1, i), 2, Format.AFFIX_LENS.LONG, Dec.seperator, Dec.decimalPoint))
