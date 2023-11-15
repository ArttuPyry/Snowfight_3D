class_name PlayerFallState
extends PlayerState

const SPEED = 2.0
@onready var player = $"../.."
@onready var camera = $"../../Camera3D"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

# let's player move on air
func _physics_process(delta) -> void:
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	else:
		state_transition.emit(self, "PlayerIdleState")
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	player.move_and_slide()

func _process(_delta):
	if Input.is_action_pressed("look_left"):
		player.rotate_y(0.03)
	
	if Input.is_action_pressed("look_right"):
		player.rotate_y(-0.03)
	
	if Input.is_action_pressed("look_up"):
		camera.rotate_x(0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	if Input.is_action_pressed("look_down"):
		camera.rotate_x(-0.02)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

