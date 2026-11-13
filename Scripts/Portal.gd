extends Area2D

func _on_Portal_body_entered(_body):
	Events.emit_signal("switch_scene", "res://Scenes/Battle.tscn")
