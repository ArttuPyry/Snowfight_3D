class_name PlayerDestroySnowmanState
extends PlayerState

@onready var animation_player = $"../../AnimationPlayer"
@onready var hands = $"../../Camera3D/Hands"
@onready var player = $"../.."
@onready var snowball = $"../../Camera3D/Hands/snowball"

func _ready() -> void:
	hands.visible = false
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)

func _enter_state() -> void:
	# Set hands to original position and make em visible
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = true
	snowball.visible = false
	set_process(true)
	set_physics_process(true)
	player.set_process_unhandled_input(false)
	
	player.velocity.x = 0
	player.velocity.z = 0
	
	# Play animation
	animation_player.play("destroy_snowman")
	await get_tree().create_timer(1.1, false).timeout
	
	# This sets off the snow splash and breaking
	player.interactable.play_snow_splash()
	player.interactable.swap_to_destroyed()
	await animation_player.animation_finished
	
	await get_tree().create_timer(0.8, false).timeout
	
	state_transition.emit(self, "PlayerIdleState")

func _exit_state() -> void:
	# Reset and invisible
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = false
	animation_player.stop(true)
	set_process(false)
	set_physics_process(false)
	player.set_process_unhandled_input(true)

func _process(_delta) -> void:
	if player.no_energy:
		state_transition.emit(self, "PlayerLoseState")
