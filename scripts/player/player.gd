extends CharacterBody3D

# Crosshari setup
@onready var user_interface = $"../UserInterface"
var crosshair
@onready var camera = $Camera3D

@export_category("Player stats")
@export var max_energy : int = SaveManager.player_max_energy
var current_health
@export var max_snowball_count : int = 9
var current_snowball_count : int
var no_energy = false

@export var mouse_enabled = true
@export var leading_crosshair = false
# These are changed with gameplay prefernece settings but just in case @export
@export var horizontal_sensitivity : float = 5.0
@export var vertical_sensitivity : float = 3.0
@export var hor_mouse_sensitivity : float = 0.01
@export var ver_mouse_sensitivity : float = 0.01
@onready var hands = $Camera3D/Hands

# This is for ladders and snowmen, climb and destory
var interactable
var interactable_group
var interact_look_at

var mission_completed = false

# User gameplay preference save
const CONFIG_SAVE_PATH := "user://usergameplaypreferences.cfg"

var snowmen

func _ready() -> void:
	var save : = ConfigFile.new()
	save.load(SaveManager.SAVE_PATH)
	snowmen = get_tree().get_nodes_in_group("snowman").size()
	
	# Hides mouse and setups UI and snowball
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_snowball_count = max_snowball_count
	user_interface.setup_ui(max_energy, save.get_value("save", "energy", max_energy), max_snowball_count)
	
	load_user_config()
	
	current_health = max_energy
	
	set_process_unhandled_input(false)
	await get_tree().create_timer(0.5, false).timeout
	set_process_unhandled_input(true)


func snowman_destroyed() -> void:
	snowmen -= 1
	user_interface.update_mission()
	if snowmen <= 0:
		mission_completed = true

func load_user_config() -> void:
	# Load user gameplay preference settings
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	# Load
	var mouse = config.get_value("gameplay_preferences", "mouse_bool", false)
	var leading = config.get_value("gameplay_preferences", "leading_bool", false)
	var fov = config.get_value("gameplay_preferences", "fov_index", 75)
	var kb_h_sens = config.get_value("gameplay_preferences", "kb_hori_float", 5)
	var kb_v_sens = config.get_value("gameplay_preferences", "kb_vert_float", 5)
	var mouse_h_sens = config.get_value("gameplay_preferences", "mouse_hori_float", 5)
	var mouse_v_sens = config.get_value("gameplay_preferences", "mouse_vert_float", 5)
	
	# Setup
	horizontal_sensitivity = kb_h_sens / 5
	vertical_sensitivity = kb_v_sens / 5
	hor_mouse_sensitivity = mouse_h_sens / 100
	ver_mouse_sensitivity = mouse_v_sens / 100
	mouse_enabled = mouse
	leading_crosshair = leading
	camera.fov = int(fov)
# Update UI - Health / Energy
func update_health_bar(damage) -> void:
	current_health -= damage
	user_interface.update_energy(damage)
# Update UI - Ammo
func update_ammo_count() -> void:
	user_interface.update_ammo()

func you_lost() -> void:
	user_interface.you_lost()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Open settings
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		user_interface.open_pause_menu()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Handle loseing (open u lose n00b menu)
func no_health() -> void:
	no_energy = true

# This thing handles aiming setup in process! Much cleaner to keep this here than copy paste it to almost every state
func aim_and_rotate(delta) -> void:
	var max_offset_hor = get_viewport().get_visible_rect().size.x / 2 * 0.5
	var max_offset_ver = get_viewport().get_visible_rect().size.y / 2 * 0.5
	
	if Input.is_action_pressed("look_left"):
		if leading_crosshair and crosshair.position.x > -max_offset_hor:
			crosshair.position.x -= get_viewport().get_visible_rect().size.x / 2 * 0.003
		self.rotate_y(horizontal_sensitivity * delta)
		hands.rotate_y(-horizontal_sensitivity * delta)
	elif leading_crosshair and crosshair.position.x < 0 and not Input.is_action_pressed("look_left"):
		crosshair.position.x += 5
	
	if Input.is_action_pressed("look_right"):
		if leading_crosshair and crosshair.position.x < max_offset_hor:
			crosshair.position.x += get_viewport().get_visible_rect().size.x / 2 * 0.003
		self.rotate_y(-horizontal_sensitivity * delta)
		hands.rotate_y(horizontal_sensitivity * delta)
	elif leading_crosshair and crosshair.position.x > 0 and not Input.is_action_pressed("look_right"):
		crosshair.position.x -= 5
	
	if Input.is_action_pressed("look_up"):
		if leading_crosshair and crosshair.position.y > -max_offset_ver:
			crosshair.position.y -= get_viewport().get_visible_rect().size.y / 2 * 0.003
		camera.rotate_x(vertical_sensitivity * delta)
		hands.rotate_x(-vertical_sensitivity * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		hands.rotation.x = clamp(hands.rotation.x, deg_to_rad(-40), deg_to_rad(40))
	elif leading_crosshair and crosshair.position.y < 0 and not Input.is_action_pressed("look_up"):
		crosshair.position.y += 5
	
	if Input.is_action_pressed("look_down"):
		if leading_crosshair and crosshair.position.y < max_offset_ver:
			crosshair.position.y += get_viewport().get_visible_rect().size.y / 2 * 0.003
		camera.rotate_x(-vertical_sensitivity * delta)
		hands.rotate_x(vertical_sensitivity * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		hands.rotation.x = clamp(hands.rotation.x, deg_to_rad(-40), deg_to_rad(40))
	elif leading_crosshair and crosshair.position.y > 0 and not Input.is_action_pressed("look_down"):
		crosshair.position.y -= 5

# Mouse corsshair reset
func _process(_delta):
	if leading_crosshair and mouse_enabled:
		if crosshair.position.x < 0 and not Input.get_last_mouse_velocity().x < 0:
			crosshair.position.x += 5
		if crosshair.position.x > 0 and not Input.get_last_mouse_velocity().x > 0:
			crosshair.position.x -= 5
		if crosshair.position.y < 0 and not Input.get_last_mouse_velocity().y < 0:
			crosshair.position.y += 5
		if crosshair.position.y > 0 and not Input.get_last_mouse_velocity().y > 0:
			crosshair.position.y -= 5

# Basic mouse input
func _unhandled_input(event):
	if mouse_enabled and event is InputEventMouseMotion:
		var max_offset_hor = get_viewport().get_visible_rect().size.x / 2 * 0.5
		var max_offset_ver = get_viewport().get_visible_rect().size.y / 2 * 0.5
		
		self.rotate_y(-event.relative.x * hor_mouse_sensitivity)
		camera.rotate_x(-event.relative.y * ver_mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		hands.rotate_y(event.relative.x * hor_mouse_sensitivity)
		
		if leading_crosshair:
			if event.relative.x < 0:
				if crosshair.position.x > -max_offset_hor:
					crosshair.position.x -= get_viewport().get_visible_rect().size.x / 2 * 0.005
			if event.relative.x > 0:
				if crosshair.position.x < max_offset_hor:
					crosshair.position.x += get_viewport().get_visible_rect().size.x / 2 * 0.005
			if event.relative.y < 0:
				if crosshair.position.y > -max_offset_ver:
					crosshair.position.y -= get_viewport().get_visible_rect().size.y / 2 * 0.005
			if event.relative.y > 0:
				if crosshair.position.y < max_offset_ver:
					crosshair.position.y += get_viewport().get_visible_rect().size.y / 2 * 0.005
