extends KinematicBody2D

export(int) var speed = 100
export(int) var max_health = 100
var health = max_health

var dash_speed = 300

var dash_time := 0.2
var dash_cooldown := 0.5

var velocity = Vector2()
var dash_direction: Vector2
var dash_counter: int = 0
var can_dash: bool = true
var is_dashing: bool = false

var in_ghost_mode: bool = false
var can_ghost_swap = true

var body_instance
var player_body_scene = preload("res://Scenes/PlayerBody.tscn")

var invincibility_time := 0.15
var invincible := false

var died := false

func _ready():
	Events.connect("altar_destroyed", self, "set_upgrade")

func set_upgrade(altars_destroyed):
	match altars_destroyed:
		1:
			speed = 150
		2:
			dash_cooldown = 0.2
		3:
			$Bow.fast_charge = true
		4:
			$Bow.pierce = true

func get_input():
	if died:
		return
	if Input.is_action_just_pressed("right_click") and can_ghost_swap:
		can_ghost_swap = false
		in_ghost_mode = !in_ghost_mode
		Events.emit_signal("ghost_mode", in_ghost_mode)
		$GhostCooldownTimer.start()
		if !in_ghost_mode:
			exit_ghost_mode()
		else:
			enter_ghost_mode()
	
	var direction = Vector2()
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	direction = direction.normalized()
	velocity = direction * speed
	
	if Input.is_action_just_pressed("dash") and can_dash:
		SoundManager.play("res://Audio/SFX/Dash.wav")
		can_dash = false
		is_dashing = true
		dash_direction = direction
		$DashTimer.start(dash_time)
		$DashParticles.emitting = true
		$DashParticles.rotation = dash_direction.angle() + PI

func _physics_process(delta):
	get_input()
	if is_dashing:
		var dash_velocity = dash_direction * dash_speed
		velocity = move_and_slide(dash_velocity)
	else:
		velocity = move_and_slide(velocity)
	if velocity.x != 0:
		$Sprite.flip_h = (velocity.x < 0)
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")

func damage(amount):
	if invincible or died:
		return
	
	SoundManager.play("res://Audio/SFX/Hurt.wav")
	$Camera2D.add_trauma(0.6)
	invincible = true
	health -= amount
	if health <= 0:
		health = 0
		die()
	Events.emit_signal("player_damaged", health)
	$InvincibilityTimer.start(invincibility_time)
	$Sprite.self_modulate = Color(1.0, 0.4, 0.4, 0.5)

func _on_InvincibilityTimer_timeout():
	invincible = false
	$Sprite.self_modulate = Color.white

func die():
	died = true
	Events.emit_signal("died")
	$Bow.died = true
	$DeathTween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2.0)
	$DeathTween.start()
	yield($DeathTween, "tween_all_completed")
	Events.emit_signal("switch_scene", "res://Scenes/Title Screen.tscn")

func snap_back_to_body():
	$GhostModeTween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$GhostModeTween.interpolate_property($Bow, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$GhostModeTween.start()

func enter_ghost_mode():
	$Sprite.modulate = Color(1.5, 1.5, 1.5)
	$GhostParticles.emitting = true
	$GhostSwapParticles.emitting = true
	$Bow.visible = true
	SoundManager.play("res://Audio/SFX/GhostModeEnter.wav")
	
func exit_ghost_mode():
	snap_back_to_body()
	$GhostParticles.emitting = false
	$GhostSwapParticles.emitting = true
	SoundManager.play("res://Audio/SFX/GhostModeExit.wav")

func _on_DashCooldownTimer_timeout():
	can_dash = true

func _on_DashTimer_timeout():
	is_dashing = false
	$DashCooldownTimer.start(dash_cooldown)

func _on_GhostCooldownTimer_timeout():
	$Sprite.modulate.a = 1.0
	$Bow.modulate.a = 1.0
	can_ghost_swap = true

func _on_GhostModeTween_tween_all_completed():
	var player_body_pos = get_parent().get_node("PlayerBody").global_position
	set_deferred("global_position", player_body_pos)
	$Sprite.modulate = Color(1.0, 1.0, 1.0)
	get_parent().get_node("PlayerBody").visible = false
	$Bow.visible = false
	
