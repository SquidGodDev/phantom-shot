extends Node2D

var is_reloading: bool = false
var reload_time: float = 0.8

var arrow_scene = preload("res://Scenes/Arrow.tscn")

var draw_pos := 1

var in_ghost_mode := false

var pierce := false
var fast_charge := false

var died := false

var bow_drawn := false
var full_draw := false

func _ready():
	Events.connect("ghost_mode", self, "_ghost_mode")
	visible = false
	
func _ghost_mode(entering):
	in_ghost_mode = entering

func _physics_process(delta):
	
	if !in_ghost_mode or died:
		return
		
	if is_reloading:
		$AnimationPlayer.play("idle")
		return
	
	if Input.is_action_just_released("click"):
		SoundManager.play("res://Audio/SFX/ArrowShot.wav")
		$ArrowShotParticles.emitting = false
		fire_arrow()
		bow_drawn = false
		full_draw = false
		return
		
	if Input.is_action_pressed("click"):
		if !bow_drawn:
			bow_drawn = true
			SoundManager.play("res://Audio/SFX/BowDraw.wav")
		$ArrowShotParticles.emitting = true
		if $Sprite.frame == 3:
			$AnimationPlayer.play("full_charge")
			if !full_draw:
				full_draw = true
#				SoundManager.play("res://Audio/SFX/FullDrawSparkle.wav")
		else:
			if fast_charge:
				$AnimationPlayer.play("charge_fast")
			else:
				$AnimationPlayer.play("charge")
		draw_pos = $Sprite.frame
	else:
		$AnimationPlayer.play("loaded")
	
func _process(delta):
	look_at(get_global_mouse_position())

func fire_arrow():
	Events.emit_signal("screen_shake", 0.2 + 0.1*(draw_pos))
	is_reloading = true
	$ReloadTimer.start(reload_time)
	var arrow_instance = arrow_scene.instance()
	arrow_instance.global_position = $ArrowSpawn.global_position
	arrow_instance.set_speed(draw_pos)
	arrow_instance.pierce = pierce
	get_tree().root.add_child(arrow_instance)

func _on_ReloadTimer_timeout():
	is_reloading = false
