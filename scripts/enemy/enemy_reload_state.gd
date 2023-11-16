class_name EnemyReloadState
extends EnemyState

@onready var current_actor = $"../.."
@onready var animation_player = $"../../AnimationPlayer"

func _ready():
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	while current_actor.current_snowball_count < current_actor.max_snowball_count:
		# Reset crosshair
		animation_player.play("reload_snowball")
		await animation_player.animation_finished
		
		
		current_actor.current_snowball_count += 1
	
	if current_actor.current_snowball_count > current_actor.max_snowball_count:
		current_actor.current_snowball_count = current_actor.max_snowball_count
	
	state_transition.emit(self, "EnemyChaseState")

func _exit_state() -> void:
	set_process(false)

func _process(_delta) -> void:
	if current_actor.is_stunned:
		current_actor.current_snowball_count = 0
		state_transition.emit(self, "EnemyStunnedState")
