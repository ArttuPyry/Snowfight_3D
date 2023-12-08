class_name BossStunnedState
extends EnemyState

@onready var animation_player = $"../../AnimationPlayer"
@onready var break_audio = $"../../BreakAudio"

func _enter_state() -> void:
	break_audio.play()
	animation_player.play("stunned_start")
	await animation_player.animation_finished
	animation_player.play("stunned")
	await get_tree().create_timer(3, false).timeout
	animation_player.play("stunned_end")
	await animation_player.animation_finished
	state_transition.emit(self, "BossIdleState")
