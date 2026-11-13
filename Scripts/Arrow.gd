extends Area2D

export(int) var draw_multiplier = 200
export(int) var arrow_speed_base = 100
export(int) var damage_multiplier = 5
export(int) var damage_base = 5
var arrow_speed
var shoot_direction
var arrow_acceleration = 10
var draw_level

var pierce = false

func _ready():
	var mouse_pos = get_global_mouse_position()
	shoot_direction = (mouse_pos-global_position).normalized()
	look_at(mouse_pos)
	
func _physics_process(delta):
	global_position += shoot_direction * arrow_speed * delta

func set_speed(_draw_level):
	draw_level = _draw_level
	arrow_speed = arrow_speed_base + draw_level * draw_multiplier

func _on_Arrow_body_entered(body):
	if body.name != "TileMap":
		Events.emit_signal("screen_shake", 0.3)
		var damage_amount = damage_base + damage_multiplier * draw_level
		body.damage(damage_amount)
		if pierce:
			return
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	$ArrowShotParticles.emitting = false
	$HitParticles.emitting = true
	arrow_speed *= .1
	$ArrowBreakSFX.play()
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
