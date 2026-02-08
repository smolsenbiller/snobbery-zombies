extends CharacterBody2D

var gun_position: Vector2
var gun_rotation: float
var gun_direction: float
var speed: float = 200.0
var max_collisions: int = 1
var damage : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = gun_position
	global_rotation = gun_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2(speed,0).rotated(gun_direction)
	
	#Set up for hit detection
	var collision = move_and_collide(velocity * delta)
	var collision_count = 0
	
	#Start the process where you detect what the collision collided with
	while collision and collision_count < max_collisions:
		var collider = collision.get_collider()
		
		#Looking for the "class_name" of Zombie
		if collider is Zombie:
			queue_free()
			collider.hit()
			break
		else:
			var normal = collision.get_normal()
			var remainder = collision.get_remainder()
			velocity = velocity.bounce(normal)
			remainder = remainder.bounce(normal)
			
			collision_count += 1
			collision = move_and_collide(remainder)
	
	move_and_slide()


func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if not area.is_in_group("zombie"):
		return
	queue_free()
