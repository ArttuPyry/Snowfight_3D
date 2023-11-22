class_name PlayerReloadState
extends PlayerState

@onready var player = $"../.."

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	player.mouse_enabled = false
	while player.current_snowball_count < player.max_snowball_count:
		# Reset crosshair
		player.crosshair.position.x = 0
		player.crosshair.position.y = 0
		
		#Need to add animations and mby reload cancel
		await get_tree().create_timer(1, false).timeout
		
		player.current_snowball_count += 1
	await get_tree().create_timer(0.01, false).timeout
	state_transition.emit(self, "PlayerIdleState")

func _exit_state() -> void:
	set_process(false)
	player.mouse_enabled = true
