class_name PlayerAttackState
extends PlayerState

const Snowball = preload("res://snowball.tscn")
@onready var shoot_spot = $"../../ShootSpot"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	print("Enter ATTACK state")
	var _snowball = Snowball.instantiate()
	shoot_spot.add_child(_snowball)
	_snowball.apply_central_force(-shoot_spot.global_transform.basis.z * 200)
	await get_tree().create_timer(0.1, false).timeout
	state_transition.emit(self, "PlayerIdleState")
	

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
