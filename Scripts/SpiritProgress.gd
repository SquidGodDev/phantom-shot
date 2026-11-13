extends ProgressBar

func _ready():
	modulate.a = 0
	Events.connect("altar_activated", self, "on_altar_activated")
	Events.connect("spirit_killed", self, "on_spirit_killed")

func on_altar_activated(souls_amount):
	max_value = souls_amount
	value = 0
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
func on_spirit_killed():
	value += 1
	if value >= max_value:
		$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
