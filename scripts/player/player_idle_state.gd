class_name PlayerIdleState
extends PlayerState

@onready var player = $"../.."
@onready var camera = $"../../Camera3D"
@onready var snowball_throw_spot = $"../../Camera3D/player_hand/player_hand/SnowballThrowSpot"

var cent_crosshair_x
var cent_crosshair_y

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _process(_delta) -> void:
	if player.ladder_position and Input.is_action_pressed("test_key"):
		player.global_position.x = player.ladder_position.x
		player.global_position.z = player.ladder_position.z
		player.look_at(Vector3(player.ladder_look_at.x, player.global_position.y, player.ladder_look_at.z), Vector3.UP)
		state_transition.emit(self, "PlayerClimbState")
	
	if Input.is_action_pressed("move_forward") \
	or Input.is_action_pressed("move_backwards") \
	or Input.is_action_pressed("move_left") \
	or Input.is_action_pressed("move_right"):
		state_transition.emit(self, "PlayerRunState")
	
	player.aim_and_rotate()
	
	if Input.is_action_just_pressed("attack"):
		state_transition.emit(self, "PlayerAttackState")
	
	if Input.is_action_just_pressed("reload") and player.current_snowball_count < player.max_snowball_count:
		state_transition.emit(self, "PlayerReloadState")

func _physics_process(_delta) -> void:
	if not player.is_on_floor():
		state_transition.emit(self, "PlayerFallState")
