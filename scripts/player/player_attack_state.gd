class_name PlayerAttackState
extends PlayerState

# Just needed variables
const Snowball = preload("res://weapons and ammo/snowball.tscn")
@onready var player = $"../.."
@onready var snowball_throw_spot = $"../../Camera3D/PlayerHandThrow/player_hand/SnowballThrowSpot"
@onready var animation_player = $"../../AnimationPlayer"
@onready var player_hand_throw = $"../../Camera3D/PlayerHandThrow"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	# Checks snowball count
	if player.current_snowball_count > 0:
		
		# Starts attack animation and at perfect time 0.1 sec instantiate snowball and throw
		animation_player.play("attack")
		await get_tree().create_timer(0.1, false).timeout
		
		# Instantiate, position and apply force
		var _snowball = Snowball.instantiate()
		_snowball.attacking_actor = "player"
		snowball_throw_spot.add_child(_snowball)
		_snowball.apply_central_force(-snowball_throw_spot.global_transform.basis.z * 200)
		
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
