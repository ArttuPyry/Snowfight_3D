class_name EnemyPatrolState
extends EnemyState

@onready var navigation_agent = $"../../NavigationAgent3D"
@onready var current_actor = $"../.."
@onready var animation_player = $"../../AnimationPlayer"

@onready var step_audio = $"../../StepAudio"

var current_waypoint_index = 0
var patrol_points
var next_spot

func _ready():
	set_process(false)
	# Set patrol points
	patrol_points = current_actor.enemy_patrol_waypoints

func _enter_state() -> void:
	# Rotate between points
	current_waypoint_index += 1
	if current_waypoint_index == patrol_points.size():
		current_waypoint_index = 0
	set_process(true)
	animation_player.play("running")
	next_spot = patrol_points[current_waypoint_index]

func _exit_state() -> void:
	set_process(false)

func _process(delta):
	if current_actor.is_stunned:
		state_transition.emit(self, "EnemyStunnedState")
	
	if current_actor.seen_player: # If seen player attack
		state_transition.emit(self, "EnemyChaseState")
	
	# Just walk
	current_actor.velocity = Vector3.ZERO
	
	navigation_agent.set_target_position(next_spot.global_transform.origin)
	var next_nav_point = navigation_agent.get_next_path_position()
	current_actor.velocity = (next_nav_point - current_actor.global_transform.origin).normalized() * current_actor.speed
	
	# Rotate smoothly
	var direction = (next_nav_point - current_actor.global_position)
	current_actor.rotation.y = lerp_angle(current_actor.rotation.y, atan2(-direction.x, -direction.z), delta * 10)
	
	if current_actor.global_transform.origin.distance_to(next_spot.global_transform.origin) < 2:
		state_transition.emit(self, "EnemyIdleState")
	
	step_audio.play_step_sound()
	current_actor.move_and_slide()
	
