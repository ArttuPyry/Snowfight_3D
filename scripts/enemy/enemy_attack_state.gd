class_name EnemyAttackState
extends EnemyState

const Snowball = preload("res://weapons and ammo/snowball.tscn")
@onready var current_actor = $"../.."
@onready var snowball_throw_spot = $"../../Armature/Skeleton3D/BoneAttachment3D/SnowballThrowSpot"

@onready var animation_player = $"../../AnimationPlayer"
@onready var shovel_attack = $"../../ShovelAttack"

var NUM_OF_ITERATIONS = 5

var speedy = 10

var is_attcking = false

func _ready():
	shovel_attack.attacking_actor = "enemy"
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	
	# 0 = snowball, 1 = shovel
	if current_actor.attack_type == 0 and current_actor.current_snowball_count > 0:
		_throw_snowball()
	elif current_actor.attack_type == 0 and current_actor.current_snowball_count <= 0: 
		state_transition.emit(self, "EnemyReloadState")
	
	if current_actor.attack_type == 1:
		_shovel_snow()

func _exit_state() -> void:
	set_process(false)

func _throw_snowball():
	is_attcking = true
	animation_player.play("throw_attack")
	await get_tree().create_timer(0.6, false).timeout
	
	var _snowball = Snowball.instantiate()
	_snowball.attacking_actor = "enemy"
	snowball_throw_spot.add_child(_snowball)
	
	var projectile_start_pos = snowball_throw_spot.global_transform.origin
	var target_start_pos = current_actor.player.global_transform.origin
	var target_velocity = current_actor.player.velocity / 6 # this nees more testing
	var target_future_pos = target_start_pos
	var final_angle = 0.0
	for i in range(NUM_OF_ITERATIONS):
		var dist_to_target = projectile_start_pos.distance_to(target_future_pos)
		var target_height = target_future_pos.y - projectile_start_pos.y
		var angle = _get_angle_to_target_point(dist_to_target, target_height, speedy, _snowball.gravity_scale)
		if angle == null:
			is_attcking = false
			return Vector3.INF
		var time_in_air = dist_to_target / (cos(angle) * speedy)
		
		target_future_pos = target_start_pos + target_velocity * time_in_air
		final_angle = angle
	
	var temp_vector = target_future_pos - projectile_start_pos
	var y_rotation = atan2(-temp_vector.x, -temp_vector.z)
	var predictive_dir = Vector3.FORWARD.rotated(Vector3.RIGHT, final_angle).rotated(Vector3.UP, y_rotation)
	
	current_actor.current_snowball_count -= 1
	_snowball.apply_central_force(projectile_start_pos + predictive_dir * 20.0 * 21)
	await animation_player.animation_finished
	is_attcking = false

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
	animation_player.play("shovel_attack")
	await animation_player.animation_finished
	state_transition.emit(self, "EnemyChaseState")

func _process(_delta):
	if current_actor.is_stunned:
		state_transition.emit(self, "EnemyStunnedState")
		
	if current_actor.attack_type == 0:
		if current_actor.current_snowball_count > 0 and is_attcking == false:
			current_actor.look_at(Vector3(current_actor.player.global_position.x, current_actor.global_position.y, current_actor.player.global_position.z), Vector3.UP)
			_throw_snowball()
		
		if current_actor.current_snowball_count <= 0:
			state_transition.emit(self, "EnemyReloadState")
		
		if current_actor.current_snowball_count > 0 and not current_actor.target_in_range():
			state_transition.emit(self, "EnemyChaseState")
