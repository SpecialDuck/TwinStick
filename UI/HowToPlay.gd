extends Popup

func _ready():
	$VBoxContainer/DoneButton.grab_focus()

func _on_DoneButton_pressed():
	self.hide()
