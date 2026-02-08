extends Sprite2D
class_name ammoCalc
@onready var ammo_text : Label = $"../../Camera2D/CanvasLayer/AmmoCount"
@onready var player : CharacterBody2D = $"../.."

var max_ammo : int
var reserve_ammo : int
var active_ammo_max : int
var active_ammo : int
var reloading : bool = false

func _ready() -> void:
	max_ammo = 80
	reserve_ammo = 32
	active_ammo_max = 8
	active_ammo = 8

func update_ammo():
	ammo_text.text = str(active_ammo) + " / " + str(reserve_ammo)

func ammo_calc():
	active_ammo -= 1
	ammo_text.text = str(active_ammo) + " / " + str(reserve_ammo)

func reload_calc():
	var missing_ammo = active_ammo_max - active_ammo
	if reserve_ammo >= missing_ammo:
		reloading = true
		player.reload_anim()
		await get_tree().create_timer(1.0).timeout
		active_ammo += missing_ammo
		reserve_ammo -= missing_ammo
		reloading = false
	elif reserve_ammo > 0 and reserve_ammo < missing_ammo:
		reloading = true
		player.reload_anim()
		await get_tree().create_timer(1.0).timeout
		active_ammo += reserve_ammo
		reserve_ammo -= reserve_ammo
		reloading = false
	elif reserve_ammo == 0:
		pass
	
	ammo_text.text = str(active_ammo) + " / " + str(reserve_ammo)
