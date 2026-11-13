extends ColorRect

var switching_scene := false

func _ready():
	modulate.a = 1.0
	get_tree().get_root().set_disable_input(false)
	Events.connect("switch_scene", self, "on_switch_scene")
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	visible = false
	
func on_switch_scene(scene_path):
	if switching_scene:
		return
	switching_scene = true
	visible = true
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().change_scene(scene_path)
