extends Popup

signal new_game

func _on_BtnNewGame_pressed():
	emit_signal("new_game")


func _on_BtnQuit_pressed():
	get_tree().quit()
