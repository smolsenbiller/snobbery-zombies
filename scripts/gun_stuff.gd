extends Node

#func fire():
	#if gun_sprite.active_ammo > 0:
		#var add_rad : float = 0
		#for i in 3:
			#add_rad += 0.01
			#var bullet = bullet_path.instantiate()
			#bullet.gun_direction = pivot.rotation
			#bullet.gun_position = gun.global_position
			#bullet.gun_rotation = pivot.rotation + add_rad
			#get_parent().add_child(bullet)
	#gun_sprite.ammo_calc()
