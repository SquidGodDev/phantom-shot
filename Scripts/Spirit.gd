extends KinematicBody2D

export(float) var attack_cd = 1.5
export(int) var attack_distance = 50
export(int) var move_speed = 50

export(int) var max_health = 50
var health

var died = false

var target

export(PackedScene) var spirit_projectile_scene

func _ready():
	$EnemyHealthBar.max_value = max_health
	$EnemyHealthBar.value = max_health
	health = max_health
	modulate.a = 0
	$DetectionArea/CollisionShape2D.set_deferred("disabled", true)
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$DetectionArea/CollisionShape2D.set_deferred("disabled", false)

func _physics_process(delta):
	if died:
		return
	if target:
		var player_pos = target.global_position
		var distance = global_position.distance_to(player_pos)
		if distance > attack_distance:
			var direction = (player_pos - global_position).normalized()
			move_and_slide(direction * move_speed)

func _on_DetectionArea_body_entered(body):
	if !target:
		target = body
		$AttackTimer.start(attack_cd)

func _on_AttackTimer_timeout():
	if died:
		return
	$GhostShot.play()
	var projectile_direction = (target.global_position - global_position).normalized()
	var projectile_instance = spirit_projectile_scene.instance()
	projectile_instance.global_position = global_position
	projectile_instance.initialize_projectile(projectile_direction)
	get_tree().root.add_child(projectile_instance)

func damage(amount):
	$GhostHurt.play()
	health -= amount
	if health <= 0:
		health = 0
		die()
	$EnemyHealthBar.value = health
	$SpiritParticles.self_modulate = Color(1.0, 0.4, 0.4, 0.5)
	yield(get_tree().create_timer(0.1), "timeout")
	$SpiritParticles.self_modulate = Color.white

func die():
	$GhostDeath.play()
	Events.emit_signal("spirit_killed")
	$SpiritParticles.emitting = false
	died = true
	$EnemyHealthBar.visible = false
	$HitBox.set_deferred("disabled", true)
	$Tween.interpolate_property($GhostNoise, "volume_db", $GhostNoise.volume_db, -100, 2.0)
	$Tween.start()
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
