class_name EnemyStunnedState
extends EnemyState

@onready var animation_player = $"../../AnimationPlayer"
@onready var current_actor = $"../.."
@onready var energy_component = $"../../EnergyComponent"

@onready var break_audio = $"../../BreakAudio"

@onready var timer = $Timer
@onready var stun_label = $"../../StunLabel"

var text

func _enter_state() -> void:
	# stun enemy wait and reset
	text = current_actor.stun_duration
	timer.start()
	stun_label.text = str(text)
	stun_label.visible = true
	break_audio.play()
	animation_player.play("stunned_start")
	await animation_player.animation_finished
	animation_player.play("stunned")
	await get_tree().create_timer(current_actor.stun_duration, false).timeout
	animation_player.play("stunned_end")
	await animation_player.animation_finished
	current_actor.is_stunned = false
	energy_component.current_energy = current_actor.max_energy
	
	if current_actor.current_snowball_count > 0:
		state_transition.emit(self, "EnemyChaseState")
	else:
		state_transition.emit(self, "EnemyReloadState")

func _exit_state() -> void:
	stun_label.visible = false

func _on_timer_timeout():
	text -= 1
	if text <= 0:
		stun_label.visible = false
	stun_label.text = str(text)
	timer.start()
