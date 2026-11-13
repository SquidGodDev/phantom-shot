extends ColorRect

func _ready():
	Events.connect("ghost_mode", self, "_ghost_mode")
	
func _ghost_mode(entering):
	if entering:
		$AnimationPlayer.play("shockwave")
	else:
		$AnimationPlayer.play_backwards("shockwave")
