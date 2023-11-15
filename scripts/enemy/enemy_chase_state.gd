class_name EnemyChaseState
extends EnemyState

@onready var navigation_agent = $"../../NavigationAgent3D"
@onready var current_actor = $"../.."

func _ready():
	set_process(false)

func _enter_state() -> void:
	set_process(true)

func _exit_state() -> void:
	set_process(false)

func _process(_delta):
	if current_actor.seen_player:
		state_transition.emit(self, "EnemyChaseState")
	
	current_actor.velocity = Vector3.ZERO
	
	navigation_agent.set_target_position(current_actor.player.global_transform.origin)
	var next_nav_point = navigation_agent.get_next_path_position()
	current_actor.velocity = (next_nav_point - current_actor.global_transform.origin).normalized() * current_actor.speed
	
	current_actor.look_at(Vector3(current_actor.player.global_position.x, current_actor.global_position.y, current_actor.player.global_position.z), Vector3.UP)
	
	if current_actor.target_in_range():
		state_transition.emit(self, "EnemyAttackState")
	
	current_actor.move_and_slide()
	


