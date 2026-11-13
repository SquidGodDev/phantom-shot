extends RichTextLabel

func _ready():
	Events.connect("dialog", self, "on_dialog")
	modulate.a = 0

func on_dialog(text):
	bbcode_text = "[center]" + text + "[/center]"
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()
	yield(get_tree().create_timer(2.5), "timeout")
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0)
	$Tween.start()
	# Center text
	# Tween
	# Yield
	# Tween
	pass
