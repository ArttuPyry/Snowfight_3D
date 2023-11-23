class_name PlayerDestroySnowmanState
extends PlayerState

@onready var animation_player = $"../../AnimationPlayer"
@onready var hands = $"../../Camera3D/Hands"
@onready var player = $"../.."

func _ready() -> void:
	hands.visible = false
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = true
	set_process(true)
	set_physics_process(true)
	animation_player.play("destroy_snowman")
	await get_tree().create_timer(1.1, false).timeout
	player.interactable.play_snow_splash()
	player.interactable.swap_to_destroyed()
	await animation_player.animation_finished
	
	await get_tree().create_timer(0.8, false).timeout
	
	state_transition.emit(self, "PlayerIdleState")


func _exit_state() -> void:
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = false
	animation_player.stop(true)
	set_process(false)
	set_physics_process(false)
