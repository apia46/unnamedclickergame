extends TextureRect
@onready var achievements = $"../../../../../.."
const TEXTHOVER = preload("res://assets/ui/textHover.tscn")

var id : String
var unlocked = false
var hoverInstance
# computed
var unlockedImg = preload("res://assets/achievements/unlocked.png")
var lockedImg = preload("res://assets/achievements/locked.png")
var title = ""
var desc = ""

func _ready():
	# holy shit this is jank
	@warning_ignore("incompatible_ternary") if id == "cyyan6": unlockedImg = load("res://assets/achievements/" + (id + unlocked if typeof(unlocked) == TYPE_STRING else "unlocked") + ".png")
	else: unlockedImg = load("res://assets/achievements/" + id + ".png")

func set_data(Id,Unlocked):
	id = Id
	unlocked = Unlocked
	return self

# processes here

func _hoverStart():
	if id == "secret0":
		achievements.unlockAch("secret", 0)
		updateText()
	hoverInstance = TEXTHOVER.instantiate()
	$"/root".add_child.call_deferred(hoverInstance)

func _hoverEnd():
	hoverInstance.queue_free()

func updateOther():
	unlockedImg = load("res://assets/achievements/" + id + unlocked + ".png")

func updateText():
	match id:
		"basic0":
			title = "The only way is up"
			desc = "Get "+Dec.D(1).F("thing", true)
		"basic1":
			title = "I'm feeling lucky"
			desc = "Buy the first funny upgrade"
		"basic2":
			title = "Haha"
			desc = "Buy the third funny upgrade\n[i]:qouverjoyous:[/i]"
		"basic3":
			title = "Return on investment"
			desc = "Buy the fifth funny upgrade"
		"basic4":
			title = "Scammed"
			desc = "Buy the seventh funny upgrade"
		"basic5":
			title = "Σ2k-1"
			desc = "Buy the ninth funny upgrade\n[i]hint: ^[/i]"
		"basic6":
			title = "What did you do to my numbers?"
			desc = "Get "+Dec.D(1e6).F("thing", true)+" \n[i]read: scientific notation (e instead of x10^)[/i]"
		"cyyan0":
			title = "So many things"
			desc = "Get "+Dec.D(1).F("cyyan thing", true)
		"cyyan1":
			title = "There's more???"
			desc = "Buy the eleventh funny upgrade\n[i]to answer your question:              yeah[/i]"
		"cyyan2":
			title = "A generator is a generator"
			desc = "Buy the thirteenth funny upgrade\n[i]you can't say it's only a half[/i]"
		"cyyan3":
			title = "When do I click now???"
			desc = "Unlock the third cyyan milestone"
		"cyyan4":
			title = "Analysis paralysis"
			desc = "Unlock cyyan choices"
		"cyyan5":
			title = "It's just like the real thing!"
			desc = "Reach 1 cyyan thing per second\n[i]still e6 away, as always[/i]"
		"cyyan6":
			title = "I regret nothing"
			desc = "Buy a level 4 choice upgrade"
		"cyyan7":
			title = "Go you!"
			desc = "Unlock the eighth cyyan milestone"
		"cyyan8":
			title = "All of the above"
			desc = "Buy all the cyyan choices"
		"magenter0":
			title = "Killing time"
			desc = "win condition for now"
		"secret0":
			title = "Your curiosity is rewarded"
			desc = Dec.D(achievements.achs.secret.count(true)).F("",true)+"/"+Dec.D(len(achievements.achs.secret)).F("",true)+", these do not count toward anything"
		"secret1":
			title = " "
			desc = " \n[i]shut up about the funny upgrade numbers[/i]"
		"secret2":
			title = "Hello!"
			desc = "heya\n[i]hi[/i]"
		"secret3":
			title = "Just in case"
			desc = "it fits the art style i swear"
		"secret4":
			title = "hhhhhgh"
			desc = "bored"
		_:
			title = "error"
			desc = "invalid achievement"
	if typeof(unlocked) == TYPE_STRING or unlocked: texture = unlockedImg
	else: texture = lockedImg
	if hoverInstance != null: hoverInstance.set_data("[font_size=16]"+title+"[/font_size]\n"+(desc if typeof(unlocked) == TYPE_STRING or unlocked else "???"))
