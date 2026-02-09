extends Area2D



func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("zombie"):
		return
	roundInfo.zombies_left -= 1
