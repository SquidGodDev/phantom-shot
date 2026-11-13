extends ColorRect

var tint_transition_time = 1.0

func _ready():
	Events.connect("ghost_mode", self, "_ghost_mode")
	
func _ghost_mode(entered):
	if entered:
		$Tween.interpolate_property(self, "modulate:a", 0, 1, tint_transition_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property(self, "modulate:a", 1, 0, tint_transition_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
