extends StaticBody2D

func _ready():
	visible = false
	Events.connect("ghost_mode", self, "_ghost_mode")
	
func _ghost_mode(entering):
	if entering:
		var player_node = get_parent().get_node("Player")
		var player_pos = player_node.global_position
		var player_flip_h = player_node.get_node("Sprite").flip_h
		$PlayerBodySprite.flip_h = player_flip_h
		global_position = player_pos
		visible = true
