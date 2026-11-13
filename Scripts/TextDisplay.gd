extends RichTextLabel

func _ready():
	modulate.a = 0.0
	Events.connect("altar_activated", self, "on_altar_activated")
	Events.connect("altar_destroyed", self, "on_altar_destroyed")
	Events.connect("died", self, "on_death")

func on_death():
	bbcode_text = "[center][wave][b]Relinquished[/b][/wave][/center]"
	display_text()

func on_altar_activated(soul_count):
	bbcode_text = "[center]Altar Activated\n[wave]Sacrifice [b]" + String(soul_count) + "[/b] souls[/wave] [/center]"
	display_text()
	
func on_altar_destroyed(count):
	var upgrade_text = ""
	match count:
		1:
			upgrade_text = "You feel a wind at your feet"
		2:
			upgrade_text = "Your agility soars"
		3:
			upgrade_text = "Your bow lightens up in your hands"
		4:
			upgrade_text = "Your arrows pierce the heavens"
		5:
			upgrade_text = "Relief washes over you"
		
	bbcode_text = "[center]Altar Destroyed\n" + upgrade_text + "[/center]"
	display_text()

func display_text():
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	$TextDisplayTimer.start()
	yield($TextDisplayTimer, "timeout")
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
