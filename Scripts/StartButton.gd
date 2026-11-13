extends Button

func _on_StartButton_pressed():
	Events.emit_signal("switch_scene", "res://Scenes/Tutorial.tscn")
