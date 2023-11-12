extends Node3D

@onready var current_actor = $"../.."
var player : Node3D
var player_point

func _process(_delta) -> void:
	player = get_tree().get_first_node_in_group("player")
	player_point = player.global_transform.origin
	if _in_vision_range(player_point) and _has_line_of_sight(player_point):
		current_actor.seen_player = true
		current_actor.is_patrolling = false
		current_actor.current_target = player
		self.set_process(false)

# Vision cone
func _in_vision_range(point: Vector3) -> bool:
	var field_of_view = -self.global_transform.basis.z
	var current_actor_position = self.global_transform.origin
	var direction = point - current_actor_position
	return rad_to_deg(direction.angle_to(field_of_view)) <= current_actor.vision_arc / 2

# Raycast to check line of sight
func _has_line_of_sight(point: Vector3) -> bool:
	var space_state = get_world_3d().get_direct_space_state()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = current_actor.global_transform.origin + Vector3.UP
	params.to = point
	params.exclude = [self, current_actor]
	params.collision_mask = 1
	var result = space_state.intersect_ray(params)
	if result:
		return false # If ray collides something is blocking vision
	return true # Actor sees player
