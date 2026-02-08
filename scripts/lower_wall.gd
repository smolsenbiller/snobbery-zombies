extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	set_modulate("ffffff50")


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	set_modulate("ffffff")
