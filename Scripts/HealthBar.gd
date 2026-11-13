extends ProgressBar

func _ready():
	var player = get_parent().get_parent().get_node("Player")
	max_value = player.max_health
	value = max_value
	update_health_text()
	Events.connect("player_damaged", self, "damage")

func damage(new_health):
	value = new_health
	update_health_text()

func update_health_text():
	$HealthLabel.bbcode_text = "[center]" + String(value) + "/" + String(max_value) + "[/center]"
	
