class_name EnemyReloadState
extends EnemyState

@onready var current_actor = $"../.."

func _enter_state() -> void:
	print(current_actor, " Reloading")
	while current_actor.current_snowball_count < current_actor.max_snowball_count:
		# Reset crosshair
		await get_tree().create_timer(1, false).timeout
		
		current_actor.current_snowball_count += 1
		print(current_actor.current_snowball_count)
	
	state_transition.emit(self, "EnemyChaseState")
