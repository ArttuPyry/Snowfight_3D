class_name PlayerReloadState
extends PlayerState

@onready var player = $"../.."
@onready var hands = $"../../Camera3D/Hands"
@onready var animation_player = $"../../AnimationPlayer"

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	set_process(true)
	set_physics_process(true)
	player.set_process_unhandled_input(false)
	
	# Reload if player has less ammo than max
	if player.current_snowball_count < player.max_snowball_count:
		hands.visible = true
		animation_player.play("reload")
		await animation_player.animation_finished
		player.current_snowball_count = player.max_snowball_count
		player.update_ammo_count()
		state_transition.emit(self, "PlayerIdleState")
	
	await get_tree().create_timer(0.1, false).timeout
	state_transition.emit(self, "PlayerIdleState")

# Just reset hands
func _exit_state() -> void:
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = false
	set_process(false)
	set_physics_process(false)
	player.set_process_unhandled_input(true)


