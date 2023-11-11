class_name PlayerAttackState
extends PlayerState

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	print("Enter ATTACK state")

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)
