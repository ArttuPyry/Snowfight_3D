extends CharacterBody3D

@onready var user_interface = $"../UserInterface"
@onready var crosshair = $"../UserInterface/CenterContainer/Crosshair"
@onready var camera = $Camera3D

@export_category("Player stats")
@export var max_energy : int = 20
@export var max_snowball_count : int = 9
var current_snowball_count : int

@export var mouse_enabled = true
var sensitivity = 0.01

var ladder_position
var ladder_look_at

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_snowball_count = max_snowball_count
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func aim_and_rotate() -> void:
	pass
#	if Input.is_action_pressed("look_left"):
#		var max_offset_left = get_viewport().get_visible_rect().size.x / 2 * 0.2
#		if crosshair.position.x > -max_offset_left:
#			crosshair.position.x -= get_viewport().get_visible_rect().size.x / 2 * 0.003
#		self.rotate_y(0.03)
#	elif crosshair.position.x < 0 and not Input.is_action_pressed("look_left"):
#		crosshair.position.x += 5
#
#	if Input.is_action_pressed("look_right"):
#		var max_offset_right = get_viewport().get_visible_rect().size.x / 2 * 0.2
#		if crosshair.position.x < max_offset_right:
#			crosshair.position.x += get_viewport().get_visible_rect().size.x / 2 * 0.003
#		self.rotate_y(-0.03)
#	elif crosshair.position.x > 0 and not Input.is_action_pressed("look_right"):
#		crosshair.position.x -= 5
#
#	if Input.is_action_pressed("look_up"):
#		var max_offset_up = get_viewport().get_visible_rect().size.y / 2 * 0.2
#		if crosshair.position.y > -max_offset_up:
#			crosshair.position.y -= get_viewport().get_visible_rect().size.y / 2 * 0.003
#		camera.rotate_x(0.02)
#		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
#	elif crosshair.position.y < 0 and not Input.is_action_pressed("look_up"):
#		crosshair.position.y += 5
#
#	if Input.is_action_pressed("look_down"):
#		var max_offset_down = get_viewport().get_visible_rect().size.y / 2 * 0.2
#		if crosshair.position.y < max_offset_down:
#			crosshair.position.y += get_viewport().get_visible_rect().size.y / 2 * 0.003
#		camera.rotate_x(-0.02)
#		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
#	elif crosshair.position.y > 0 and not Input.is_action_pressed("look_down"):
#		crosshair.position.y -= 5


#func _process(_delta):
#	if crosshair.position.x < 0 and not Input.get_last_mouse_velocity().x < 0:
#		crosshair.position.x += 5
#	if crosshair.position.x > 0 and not Input.get_last_mouse_velocity().x > 0:
#		crosshair.position.x -= 5
#	if crosshair.position.y < 0 and not Input.get_last_mouse_velocity().y < 0:
#		crosshair.position.y += 5
#	if crosshair.position.y > 0 and not Input.get_last_mouse_velocity().y > 0:
#		crosshair.position.y -= 5


func _unhandled_input(event):
	if mouse_enabled and event is InputEventMouseMotion:
		var max_offset_hor = get_viewport().get_visible_rect().size.x / 2 * 0.5
		var max_offset_ver = get_viewport().get_visible_rect().size.y / 2 * 0.5
		
		self.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
#		if event.relative.x < 0:
#			if crosshair.position.x > -max_offset_hor:
#				crosshair.position.x -= get_viewport().get_visible_rect().size.x / 2 * 0.005
#		if event.relative.x > 0:
#			if crosshair.position.x < max_offset_hor:
#				crosshair.position.x += get_viewport().get_visible_rect().size.x / 2 * 0.005
#		if event.relative.y < 0:
#			if crosshair.position.y > -max_offset_ver:
#				crosshair.position.y -= get_viewport().get_visible_rect().size.y / 2 * 0.005
#		if event.relative.y > 0:
#			if crosshair.position.y < max_offset_ver:
#				crosshair.position.y += get_viewport().get_visible_rect().size.y / 2 * 0.005

func no_health():
	get_tree().quit()
