extends Node2D

export(Array, PackedScene) var spirit_scenes 

var max_enemies = 10
var altars_destroyed = 0

var spawn_time_base = 5.0
var spawn_time_multiplier = 0.5

var rng = RandomNumberGenerator.new()

func _ready():
	Events.connect("altar_destroyed", self, "on_altar_destroyed")
	rng.randomize()
	$SpawnTimer.start(spawn_time_base)

func on_altar_destroyed(count):
	altars_destroyed = count
	max_enemies += 1

func _on_SpawnTimer_timeout():
	$SpawnTimer.start(spawn_time_base - spawn_time_multiplier * altars_destroyed)
	if $Enemies.get_child_count() < max_enemies:
		var spawn_pos = get_rand_pos()
		var rand_spirit = spirit_scenes[altars_destroyed]
		var spirit_instance = rand_spirit.instance()
		spirit_instance.global_position = spawn_pos
		$Enemies.add_child(spirit_instance)

func get_rand_pos():
	var extents = $SpawnArea/CollisionShape2D.shape.get_extents()
	var x_center = $SpawnArea.global_position.x
	var y_center = $SpawnArea.global_position.y
	var rand_x = rng.randf_range(x_center-extents.x, x_center+extents.x)
	var rand_y = rng.randf_range(y_center-extents.y, y_center+extents.y)
	return Vector2(rand_x, rand_y)
