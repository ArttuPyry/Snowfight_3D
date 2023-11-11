class_name PlayerIdleState
extends PlayerState

@onready var player = $"../.."
@onready var camera = $"../../Camera3D"

var cent_crosshair_x
var cent_crosshair_y

func _ready() -> void:

	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	print("Enter IDLE state")

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _process(_delta) -> void:
	if Input.is_action_pressed("move_forward") \
	or Input.is_action_pressed("move_backwards") \
	or Input.is_action_pressed("move_left") \
	or Input.is_action_pressed("move_right"):
		state_transition.emit(self, "PlayerRunState")
	
	if Input.is_action_pressed("look_left"):
		player.crosshair.position.x += 2
		player.rotate_y(0.03)
	elif player.crosshair.position.x > 0 and not Input.is_action_pressed("look_left"):
		player.crosshair.position.x -= 5
	
	if Input.is_action_pressed("look_right"):
		player.crosshair.position.x -= 2
		player.rotate_y(-0.03)
	elif player.crosshair.position.x < 0 and not Input.is_action_pressed("look_right"):
		player.crosshair.position.x += 5
	
	if Input.is_action_pressed("look_up"):
		player.crosshair.position.y += 2
		camera.rotate_x(0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	elif player.crosshair.position.y > 0 and not Input.is_action_pressed("look_up"):
		player.crosshair.position.y -= 5
	
	if Input.is_action_pressed("look_down"):
		player.crosshair.position.y -= 2
		camera.rotate_x(-0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	elif player.crosshair.position.y < 0 and not Input.is_action_pressed("look_down"):
		player.crosshair.position.y += 5
	
	if Input.is_action_just_pressed("reload"):
		state_transition.emit(self, "PlayerReloadState")

func _physics_process(_delta) -> void:
	if not player.is_on_floor():
		state_transition.emit(self, "PlayerFallState")
