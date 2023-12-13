class_name EnemyChaseState
extends EnemyState

@onready var navigation_agent = $"../../NavigationAgent3D"
@onready var current_actor = $"../.."
@onready var animation_player = $"../../AnimationPlayer"

@onready var vision = $"../../Vision"

@onready var step_audio = $"../../StepAudio"

func _ready():
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	animation_player.play("running")

func _exit_state() -> void:
	set_process(false)

func _process(_delta):
	if current_actor.is_stunned: # Stun
		state_transition.emit(self, "EnemyStunnedState")
	
	# Baisc movement with nav mesh
	current_actor.velocity = Vector3.ZERO
	
	navigation_agent.set_target_position(current_actor.player.global_transform.origin)
	var next_nav_point = navigation_agent.get_next_path_position()
	current_actor.velocity = (next_nav_point - current_actor.global_transform.origin).normalized() * current_actor.speed
	
	current_actor.look_at(Vector3(current_actor.player.global_position.x, current_actor.global_position.y, current_actor.player.global_position.z), Vector3.UP)
	
	if current_actor.target_in_range() and vision.has_line_of_sight(current_actor.player.global_transform.origin):
		state_transition.emit(self, "EnemyAttackState")
	
	step_audio.play_step_sound()
	current_actor.move_and_slide()
	


