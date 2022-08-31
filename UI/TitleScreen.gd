extends Control

func _ready():
	$VSplitContainer/VBoxContainer/ButtonNewGame.grab_focus()

func _on_ButtonNewGame_pressed():
	get_tree().change_scene("res://Arena.tscn")


func _on_ButtonInstructions_pressed():
	$HowToPlay.popup_centered()


func _on_ButtonSettings_pressed():
	$Settings.popup_centered()


func _on_ButtonQuit_pressed():
	get_tree().quit()
