extends Control

func _on_AnimationPlayer_animation_finished(anim_name):
	Events.emit_signal("switch_scene", "res://Scenes/Title Screen.tscn")
