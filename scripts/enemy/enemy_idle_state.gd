class_name EnemyIdleState
extends EnemyState

@onready var current_actor = $"../.."

func _enter_state() -> void:
	set_process(true)

func _exit_state() -> void:
	set_process(false)

func _process(_delta):
	if current_actor.seen_player:
		state_transition.emit(self, "EnemyChaseState")
