class_name PlayerRunState
extends PlayerState

const SPEED = 4.0
@onready var player = $"../.."
@onready var camera = $"../../Camera3D"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var step_audio = $"../../StepAudio"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

# Just basic movement bit edited from Godot basic movement
func _physics_process(delta) -> void:
	if not player.is_on_floor():
		state_transition.emit(self, "PlayerFallState")
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		step_audio.play_step_sound()
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = lerp(player.velocity.x, direction.x * SPEED, delta * 3.5)
		player.velocity.z = lerp(player.velocity.z, direction.z * SPEED, delta * 3.5)
		if player.velocity.x < 0.1 and player.velocity.z < 0.1:
			player.velocity.x = 0
			player.velocity.z = 0
			state_transition.emit(self, "PlayerIdleState")
	
	player.move_and_slide()

func _process(delta):
	# Camera stuff
	player.aim_and_rotate(delta)
	
	# Interact stuff
	if player.interactable and player.interactable_group == "snowman" and Input.is_action_pressed("interact"):
		player.velocity.x = 0
		player.velocity.z = 0
		player.global_position.x = player.interactable.global_position.x
		player.global_position.z = player.interactable.global_position.z
		player.look_at(Vector3(player.interact_look_at.x, player.global_position.y, player.interact_look_at.z), Vector3.UP)
		state_transition.emit(self, "PlayerDestroySnowmanState")
	# Interact stuff
	if player.interactable and player.interactable_group == "ladder" and Input.is_action_pressed("interact"):
		player.velocity.x = 0
		player.velocity.z = 0
		player.global_position.x = player.interactable.global_position.x
		player.global_position.z = player.interactable.global_position.z
		player.look_at(Vector3(player.interact_look_at.x, player.global_position.y, player.interact_look_at.z), Vector3.UP)
		state_transition.emit(self, "PlayerClimbState")
	
	# Attack
	if Input.is_action_just_pressed("attack"):
		state_transition.emit(self, "PlayerAttackState")
	# Reload
	if Input.is_action_just_pressed("reload") and player.current_snowball_count < player.max_snowball_count:
		state_transition.emit(self, "PlayerReloadState")
	
	if player.no_energy:
		state_transition.emit(self, "PlayerLoseState")
