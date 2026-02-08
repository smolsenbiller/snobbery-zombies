extends Area2D

var buyable : bool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		purchase_mod()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$Sprite2D/cost.show()
	buyable = true

func purchase_mod():
	if buyable == true and roundInfo.player_score >= 2000:
		roundInfo.player_score -= 2000
		%Player.automatic_mod = true
		%Player.shotgun_mod = false
		%Player.automatic_ammo()
	
func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$Sprite2D/cost.hide()
	buyable = false
