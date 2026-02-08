extends Node2D

#preloading the zombie scene because eventually I will be spawning a lot of zombies
const zombie_scene = preload("res://scenes/zombie.tscn")

@onready var round_count : Label = $Player/Camera2D/CanvasLayer/RoundCount
@onready var over_text : Label = $Player/Camera2D/CanvasLayer/GameOverText
@onready var score_text : Label = $Player/Camera2D/CanvasLayer/PlayerScore

var spawn_point : Sprite2D

func _ready() -> void:
	spawn_point = get_tree().get_nodes_in_group("spawns").pick_random()
	#When the scene starts need to make sure we are on round 1
	roundInfo.round = 1
	#Need to make sure that only 4 zombies on this first round
	roundInfo.zombies_left = 4
	# Start adding zombies
	roundInfo.player_score = 500
	add_zombie()
	

func add_zombie():
	for num in roundInfo.zombies_left:
		#Instantiating the zombie scene and putting it into a vaiable
		var new_zombie = zombie_scene.instantiate()
		#Adding a position to the zombie variable
		spawn_point = get_tree().get_nodes_in_group("spawns").pick_random()
		new_zombie.position = spawn_point.position
		#Adding the zombie to the main scene
		add_child(new_zombie)
		#Delay between zombie spawns
		await get_tree().create_timer(1.0).timeout


func round_change():
	#Want to delay the start of a new round
	await get_tree().create_timer(2.0).timeout
	#Increase the round by 1 and update it on the screen
	roundInfo.round += 1
	round_count.text = str(roundInfo.round)
	#This will add zombies after round 1 and increase the amount of zombies as well
	zombie_health_calc(roundInfo.round)
	zombies_left_calc(roundInfo.round)

func zombies_left_calc(rounds : int):
	var zombies_left = rounds * 3
	roundInfo.zombies_left = zombies_left
	add_zombie()
	return zombies_left

func zombie_health_calc(rounds : int):
	var zombies_health = (rounds * 20)
	roundInfo.zombie_health = zombies_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Check to see if any zombies are left
	if roundInfo.zombies_left <= 0:
		#Need to make sure the if statement fires only once at the end of a round
		roundInfo.zombies_left = 1
		#Call a round change
		round_change()
	score_text.text = str(roundInfo.player_score)

func game_over_sequence():
	round_count.hide()
	
	if roundInfo.round > 1:
		over_text.text = "You survived " + str(roundInfo.round) + " rounds"
	else:
		over_text.text = "You survived " + str(roundInfo.round) + " round"
	
	over_text.show()
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
