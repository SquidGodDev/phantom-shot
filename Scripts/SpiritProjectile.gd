extends Area2D

export(int) var projectile_speed = 200
export(int) var projectile_damage = 5
var shoot_direction: Vector2

func initialize_projectile(direction):
	shoot_direction = direction
	
func _physics_process(delta):
	global_position += shoot_direction * projectile_speed * delta


func _on_RedSpiritProjectile_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	if body.name == "Player":
		body.damage(projectile_damage)
	projectile_speed = 50
	$SpiritProjectileParticles.emitting = false
	$HitParticles.emitting = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
