class_name EnemyAttackState
extends EnemyState

const Snowball = preload("res://snowball.tscn")
@onready var current_actor = $"../.."
@onready var shoot_spot = $"../../ShootSpot"
@onready var animation_player = $"../../AnimationPlayer"
@onready var shovel_attack = $"../../ShovelAttack"


var NUM_OF_ITERATIONS = 5

var speedy = 10

func _ready():
	shovel_attack.attacking_actor = "enemy"
	set_process(false)

func _enter_state() -> void:
	print(current_actor.current_snowball_count)
	set_process(true)
	print("me attack")
	
	# 0 = snowball, 1 = shovel
	if current_actor.attack_type == 0:
		_throw_snowball()
	elif current_actor.attack_type == 1:
		_shovel_snow()
	
	await get_tree().create_timer(1, false).timeout
	state_transition.emit(self, "EnemyChaseState")

func _throw_snowball():
	var _snowball = Snowball.instantiate()
	_snowball.attacking_actor = "enemy"
	shoot_spot.add_child(_snowball)
	
	var projectile_start_pos = shoot_spot.global_transform.origin
	var target_start_pos = current_actor.player.global_transform.origin
	var target_velocity = current_actor.player.velocity / 6 # this nees more testing
	var target_future_pos = target_start_pos
	var final_angle = 0.0
	for i in range(NUM_OF_ITERATIONS):
		var dist_to_target = projectile_start_pos.distance_to(target_future_pos)
		var target_height = target_future_pos.y - projectile_start_pos.y
		var angle = _get_angle_to_target_point(dist_to_target, target_height, speedy, _snowball.gravity_scale)
		if angle == null:
			return Vector3.INF
		var time_in_air = dist_to_target / (cos(angle) * speedy)
		
		target_future_pos = target_start_pos + target_velocity * time_in_air
		final_angle = angle
	
	var temp_vector = target_future_pos - projectile_start_pos
	var y_rotation = atan2(-temp_vector.x, -temp_vector.z)
	var predictive_dir = Vector3.FORWARD.rotated(Vector3.RIGHT, final_angle).rotated(Vector3.UP, y_rotation)
	
	print(projectile_start_pos + predictive_dir * 20.0)
	
	current_actor.current_snowball_count -= 1
	_snowball.apply_central_force(projectile_start_pos + predictive_dir * 20.0 * 21)

func _get_angle_to_target_point(distance, height, SPEED, GRAVITY):
	# Set Gravity small number 0 might crash the game (atleast thats what I heard)
	if GRAVITY == 0:
		GRAVITY = 0.001
	
	GRAVITY = GRAVITY
	# The equation: atan(SPEED^2 +- sqrt((SPEED^4 - Gravity(GRAVITY distance^2 + 25^2height))) / GRAVITYdistance)
	var root = SPEED * SPEED * SPEED * SPEED - GRAVITY * (GRAVITY * distance * distance + 2.0 * height * SPEED * SPEED)
	
	# Out of range
	if root < 0.0:
		return null
	
	root = sqrt(root)
	var sub = GRAVITY * distance
	var s_sq = SPEED * SPEED
	var angle_optimal = atan((s_sq + root) / sub)
	var angle_long = atan((s_sq - root) / sub)
	
	return min(angle_optimal, angle_long)

func _shovel_snow() -> void:
	animation_player.play("temp_attack")
	await animation_player.animation_finished

func _process(_delta):
	if current_actor.current_snowball_count > 0:
		current_actor.look_at(Vector3(current_actor.player.global_position.x, current_actor.global_position.y, current_actor.player.global_position.z), Vector3.UP)
	else:
		state_transition.emit(self, "EnemyReloadState")
