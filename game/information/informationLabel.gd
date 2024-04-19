extends RichTextLabel

# https://godotforums.org/d/19203-hyperlinks-in-richtextlabels
func _ready(): connect("meta_clicked", self.meta_clicked)
func meta_clicked(meta): OS.shell_open(meta);
