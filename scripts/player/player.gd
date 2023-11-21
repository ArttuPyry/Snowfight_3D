extends CharacterBody3D

@onready var user_interface = $"../UserInterface"
@onready var crosshair = $"../UserInterface/CenterContainer/Crosshair"
@onready var camera = $Camera3D

@export_category("Player stats")
@export var max_energy : int = 20
@export var max_snowball_count : int = 9
var current_snowball_count : int

var ladder_position
var ladder_look_at

func _ready():
	current_snowball_count = max_snowball_count

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func aim_and_rotate() -> void:
	if Input.is_action_pressed("look_left"):
		var max_offset_left = get_viewport().get_visible_rect().size.x / 2 * 0.2
		if crosshair.position.x > -max_offset_left:
			crosshair.position.x -= get_viewport().get_visible_rect().size.x / 2 * 0.003
		self.rotate_y(0.03)
	elif crosshair.position.x < 0 and not Input.is_action_pressed("look_left"):
		crosshair.position.x += 5
	
	if Input.is_action_pressed("look_right"):
		var max_offset_right = get_viewport().get_visible_rect().size.x / 2 * 0.2
		if crosshair.position.x < max_offset_right:
			crosshair.position.x += get_viewport().get_visible_rect().size.x / 2 * 0.003
		self.rotate_y(-0.03)
	elif crosshair.position.x > 0 and not Input.is_action_pressed("look_right"):
		crosshair.position.x -= 5
	
	if Input.is_action_pressed("look_up"):
		var max_offset_up = get_viewport().get_visible_rect().size.y / 2 * 0.2
		if crosshair.position.y > -max_offset_up:
			crosshair.position.y -= get_viewport().get_visible_rect().size.y / 2 * 0.003
		camera.rotate_x(0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	elif crosshair.position.y < 0 and not Input.is_action_pressed("look_up"):
		crosshair.position.y += 5
	
	if Input.is_action_pressed("look_down"):
		var max_offset_down = get_viewport().get_visible_rect().size.y / 2 * 0.2
		if crosshair.position.y < max_offset_down:
			crosshair.position.y += get_viewport().get_visible_rect().size.y / 2 * 0.003
		
		camera.rotate_x(-0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	elif crosshair.position.y > 0 and not Input.is_action_pressed("look_down"):
		crosshair.position.y -= 5

func no_health():
	get_tree().quit()
