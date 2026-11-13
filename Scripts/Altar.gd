extends Area2D

func _on_Altar_body_entered(body):
	if !body.get_node("Bow").visible:
		Events.emit_signal("altar_entered", self)

func active():
	$ActiveParticles.emitting = true

func destroy():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("destroy")
	$DestroyParticles.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	$DestroyParticles.emitting = false
	$ActiveParticles.emitting = false
