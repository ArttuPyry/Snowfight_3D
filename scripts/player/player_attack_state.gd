class_name PlayerAttackState
extends PlayerState

# Just needed variables
const Snowball = preload("res://weapons and ammo/snowball_cb.tscn")
@onready var player = $"../.."
@onready var snowball_throw_spot = $"../../Camera3D/PlayerHandThrow/player_hand/SnowballThrowSpot"
@onready var animation_player = $"../../AnimationPlayer"
@onready var player_hand_throw = $"../../Camera3D/PlayerHandThrow"

@onready var audio_throw = $"../../Throw"

const SPEED = 2.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var step_audio = $"../../StepAudio"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	
	player.velocity.x = 0
	player.velocity.z = 0
	
	# Checks snowball count
	if player.current_snowball_count > 0:
		
		# Starts attack animation and at perfect time 0.1 sec instantiate snowball and throw
		animation_player.play("attack")
		await get_tree().create_timer(0.1, false).timeout
		audio_throw.play()
		# Instantiate, position and apply force
		var _snowball = Snowball.instantiate()
		_snowball.attacking_actor = "player"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = snowball_throw_spot.global_transform
		_snowball.setup(20.0)
		
		# Update ammo count from player and UI
		player.current_snowball_count -= 1
		player.update_ammo_count()
	
	# Wait for 0.5 gonna add sound here prob if no ammo
	await get_tree().create_timer(0.5, false).timeout
	state_transition.emit(self, "PlayerIdleState")

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _process(delta):
	player.aim_and_rotate(delta)
	
	if player.no_energy:
		state_transition.emit(self, "PlayerLoseState")

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
	
	player.move_and_slide()
