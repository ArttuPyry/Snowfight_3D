class_name EnemyStunnedState
extends EnemyState

@onready var animation_player = $"../../AnimationPlayer"
@onready var current_actor = $"../.."
@onready var energy_component = $"../../EnergyComponent"

func _enter_state() -> void:
	# stun enemy wait and reset
	animation_player.play("stunned_start")
	await animation_player.animation_finished
	animation_player.play("stunned")
	await get_tree().create_timer(5, false).timeout
	animation_player.play("stunned_end")
	await animation_player.animation_finished
	current_actor.is_stunned = false
	energy_component.current_energy = current_actor.max_energy
	if current_actor.current_snowball_count > 0:
		state_transition.emit(self, "EnemyChaseState")
	else:
		state_transition.emit(self, "EnemyReloadState")
