extends CharacterBody2D

@onready var main : Node2D = $".."
@onready var pivot: Node2D = $Pivot_Anchor
@onready var gun: Sprite2D = $Pivot_Anchor/gunSprite
var speed: float = 40.0

var bullet_path: PackedScene = preload("res://scenes/bullet.tscn")
@export var animator : AnimationPlayer
@export var gun_animator : AnimationPlayer
@export var sprite : Sprite2D
@export var gun_sprite : Sprite2D

var max_collisions : int = 1
var shotgun_mod : bool = false
var automatic_mod : bool = false


func _ready() -> void:
	pass

func get_input():
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_direction * speed


func _physics_process(delta: float) -> void:
	get_input()
	if velocity != Vector2(0, 0):
		animator.play("wiggle")
	else:
		animator.play("idle")
	#set up gun rotation
	var mouse_position = get_global_mouse_position()
	pivot.look_at(mouse_position)
	if get_local_mouse_position().x < 0:
		sprite.flip_h = true
		gun_sprite.flip_v = true
	else:
		sprite.flip_h = false
		gun_sprite.flip_v = false
	
	if shotgun_mod == false and automatic_mod == false:
		if Input.is_action_just_pressed("left_click") and gun_sprite.reloading == false:
			fire()
	elif shotgun_mod == true:
		if Input.is_action_just_pressed("left_click") and gun_sprite.reloading == false:
			shotgun_fire()
	elif automatic_mod == true:
		if Input.is_action_pressed("left_click") and gun_sprite.reloading == false:
			fire()
	
	if gun_sprite.active_ammo < gun_sprite.active_ammo_max and Input.is_action_just_pressed("reload"):
		gun_sprite.reload_calc()
	
	move_and_slide()

func fire():
	if gun_sprite.active_ammo > 0:
		var bullet = bullet_path.instantiate()
		bullet.gun_direction = pivot.rotation
		bullet.gun_position = gun.global_position
		bullet.gun_rotation = pivot.rotation
		get_parent().add_child(bullet)
		gun_sprite.ammo_calc()
	elif gun_sprite.active_ammo <= 0:
		gun_sprite.reload_calc()

func shotgun_fire():
	if gun_sprite.active_ammo > 0:
		var add_rad : float = 0
		for i in 5:
			add_rad += 0.01
			var bullet = bullet_path.instantiate()
			bullet.gun_direction = pivot.rotation
			bullet.gun_position = gun.global_position
			bullet.gun_rotation = pivot.rotation + add_rad
			get_parent().add_child(bullet)
		gun_sprite.ammo_calc()
	elif gun_sprite.active_ammo <= 0:
		gun_sprite.reload_calc()

func shotgun_ammo():
	gun_sprite.max_ammo = 40
	gun_sprite.reserve_ammo = gun_sprite.max_ammo
	gun_sprite.active_ammo_max = 2
	gun_sprite.active_ammo = gun_sprite.active_ammo_max
	gun_sprite.update_ammo()

func automatic_ammo():
	gun_sprite.max_ammo = 120
	gun_sprite.reserve_ammo = gun_sprite.max_ammo
	gun_sprite.active_ammo_max = 30
	gun_sprite.active_ammo = gun_sprite.active_ammo_max
	gun_sprite.update_ammo()

func reload():
	gun_sprite.reserve_ammo = gun_sprite.max_ammo
	gun_sprite.active_ammo = gun_sprite.active_ammo_max
	gun_sprite.update_ammo()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("zombie"):
		return
	await get_tree().process_frame
	process_mode = $".".PROCESS_MODE_DISABLED
	main.game_over_sequence()

func reload_anim():
	gun_animator.play("reload")
