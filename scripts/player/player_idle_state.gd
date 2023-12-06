class_name PlayerIdleState
extends PlayerState

@onready var player = $"../.."
@onready var camera = $"../../Camera3D"
@onready var snowball_throw_spot = $"../../Camera3D/PlayerHandThrow/player_hand/SnowballThrowSpot"

@onready var reload_front_raycast = $"../../ReloadFrontRaycast"
@onready var reload_ground_raycast = $"../../ReloadGroundRaycast"

var cent_crosshair_x
var cent_crosshair_y

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	player.velocity.x = 0
	player.velocity.z = 0

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

# This just check what state should be active
func _process(delta) -> void:
	if player.interactable and player.interactable_group == "snowman" and Input.is_action_pressed("interact"):
		player.global_position.x = player.interactable.global_position.x
		player.global_position.z = player.interactable.global_position.z
		player.look_at(Vector3(player.interact_look_at.x, player.global_position.y, player.interact_look_at.z), Vector3.UP)
		state_transition.emit(self, "PlayerDestroySnowmanState")
	
	if player.interactable and player.interactable_group == "ladder" and Input.is_action_pressed("interact"):
		player.global_position.x = player.interactable.global_position.x
		player.global_position.z = player.interactable.global_position.z
		player.look_at(Vector3(player.interact_look_at.x, player.global_position.y, player.interact_look_at.z), Vector3.UP)
		state_transition.emit(self, "PlayerClimbState")
	
	if Input.is_action_pressed("move_forward") \
	or Input.is_action_pressed("move_backwards") \
	or Input.is_action_pressed("move_left") \
	or Input.is_action_pressed("move_right"):
		state_transition.emit(self, "PlayerRunState")
	
	# Let's player look around
	player.aim_and_rotate(delta)
	
	if Input.is_action_just_pressed("attack"):
		state_transition.emit(self, "PlayerAttackState")
	
	if Input.is_action_just_pressed("reload") and player.current_snowball_count < player.max_snowball_count and not reload_front_raycast.is_colliding() and reload_ground_raycast.is_colliding():
		
		state_transition.emit(self, "PlayerReloadState")
	
	if player.no_energy:
		state_transition.emit(self, "PlayerLoseState")

func _physics_process(_delta) -> void:
	if not player.is_on_floor():
		state_transition.emit(self, "PlayerFallState")
