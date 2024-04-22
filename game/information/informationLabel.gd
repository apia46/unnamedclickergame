extends RichTextLabel
@onready var game = $"/root/game"

# https://godotforums.org/d/19203-hyperlinks-in-richtextlabels
func _ready(): connect("meta_clicked", self.meta_clicked)
func meta_clicked(meta):
	if meta == "secret": game.achievements.unlockAch("secret", 2)
	else: OS.shell_open(meta)
