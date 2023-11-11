class_name PlayerRunState
extends PlayerState

const SPEED = 5.0
@onready var player = $"../.."
@onready var camera = $"../../Camera3D"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	print("Enter RUN state")

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _physics_process(delta) -> void:
	if not player.is_on_floor():
		state_transition.emit(self, "PlayerFallState")
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = lerp(player.velocity.x, direction.x * SPEED, delta * 2.0)
		player.velocity.z = lerp(player.velocity.z, direction.z * SPEED, delta * 2.0)
		if player.velocity.x == 0 and player.velocity.z == 0:
			state_transition.emit(self, "PlayerIdleState")
	
	player.move_and_slide()

func _process(_delta):
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
