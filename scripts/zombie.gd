class_name Zombie extends CharacterBody2D

#Zombie Navigation Setup
var player: CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var speed: float = 20.0
var target_position: Vector2

#main node callback setup
@onready var main : Node2D = $"."

var health : int
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	health = roundInfo.zombie_health
	
	player = get_tree().get_first_node_in_group("player")
	
	nav_agent.path_desired_distance = 1.0
	nav_agent.target_desired_distance = 1.0
	
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target_position)

func set_movement_target(movement_target: Vector2):
	nav_agent.target_position = movement_target

func _process(delta: float) -> void:
	target_position = player.position
	set_movement_target(target_position)

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	play_animation()
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func play_animation():
	if velocity != Vector2(0,0):
		animator.play("walking")
	if velocity.x > 0:
		sprite.flip_h = true
	elif  velocity.x < 0:
		sprite.flip_h = false

func _on_head_body_entered(body: Node2D) -> void:
	if not body.is_in_group("bullet"):
		return
	health -= body.damage * 2
	if health <= 0:
		roundInfo.player_score += 100
		queue_free()
		roundInfo.zombies_left -= 1
	else:
		roundInfo.player_score += 10


func _on_body_body_entered(body: Node2D) -> void:
	if not body.is_in_group("bullet"):
		return
	health -= body.damage
	if health <= 0:
		roundInfo.player_score += 60
		queue_free()
		roundInfo.zombies_left -= 1
	else:
		roundInfo.player_score += 10
