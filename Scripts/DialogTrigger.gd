extends Area2D

export(String, MULTILINE) var dialog

func _on_DialogTrigger_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	Events.emit_signal("dialog", dialog)
