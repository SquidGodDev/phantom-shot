extends Node2D

var souls_count_base = 10
var souls_count_multiplier = 5
var soul_count = 0

var cur_altar
var altars_destroyed = 0
onready var altar_count = get_child_count()

var won := false

func _ready():
	Events.connect("spirit_killed", self, "on_spirit_killed")
	Events.connect("altar_entered", self, "on_altar_entered")

func on_altar_entered(altar):
	if !cur_altar:
		SoundManager.play("res://Audio/SFX/AltarActivated.wav")
		cur_altar = altar
		altar.active()
		var souls_to_sacrifice = souls_count_base + souls_count_multiplier * altars_destroyed
		Events.emit_signal("altar_activated", souls_to_sacrifice)

func on_spirit_killed():
	if cur_altar:
		soul_count += 1
		if soul_count >= (souls_count_base + souls_count_multiplier * altars_destroyed):
			altar_destroyed()

func altar_destroyed():
	SoundManager.play("res://Audio/SFX/AltarDestroyed.wav")
	cur_altar.destroy()
	cur_altar = null
	altars_destroyed += 1
	soul_count = 0
	Events.emit_signal("altar_destroyed", altars_destroyed)
	
	if altars_destroyed >= altar_count:
		win()
		
func win():
	if won:
		return
	won = true
	get_tree().get_root().set_disable_input(true)
	Events.emit_signal("switch_scene", "res://Scenes/WinScreen.tscn")
