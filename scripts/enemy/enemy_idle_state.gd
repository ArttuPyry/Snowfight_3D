class_name EnemyIdleState
extends EnemyState

@onready var current_actor = $"../.."
@onready var animation_player = $"../../AnimationPlayer"

func _enter_state() -> void:
	set_process(true)
	await get_tree().create_timer(0.01, false).timeout
	animation_player.play("idle")
	if current_actor.patrolling:
		state_transition.emit(self, "EnemyPatrolState")

func _exit_state() -> void:
	set_process(false)

func _process(_delta) -> void:
	if current_actor.is_stunned:
		state_transition.emit(self, "EnemyStunnedState")
	
	if current_actor.seen_player:
		state_transition.emit(self, "EnemyChaseState")
