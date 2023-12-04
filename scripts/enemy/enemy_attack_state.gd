class_name EnemyAttackState
extends EnemyState

const Snowball = preload("res://weapons and ammo/snowball_cb.tscn")
@onready var current_actor = $"../.."
@onready var snowball_throw_spot = $"../../Armature/Skeleton3D/BoneAttachment3D/SnowballThrowSpot"

@onready var animation_player = $"../../AnimationPlayer"
@onready var shovel_attack = $"../../ShovelAttack"

@onready var face_target_y = $"../../Armature/Skeleton3D/BoneAttachment3D/SnowballThrowSpot/FaceTargetY"
@onready var face_target_x = $"../../Armature/Skeleton3D/BoneAttachment3D/SnowballThrowSpot/FaceTargetY/FaceTargetX"
@onready var fire_point = $"../../Armature/Skeleton3D/BoneAttachment3D/SnowballThrowSpot/FaceTargetY/FaceTargetX/FirePoint"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var NUM_OF_ITERATIONS = 5

var speedy = 20.0

func _ready():
	shovel_attack.attacking_actor = "enemy"
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	current_actor.is_attacking = true
	# Check attack and start it
	if current_actor.attack_type == 1:
		_shovel_snow()
	elif current_actor.attack_type == 0 and current_actor.current_snowball_count > 0:
		_throw_snowball()
	elif current_actor.attack_type == 0 and current_actor.current_snowball_count <= 0: 
		state_transition.emit(self, "EnemyReloadState")

func _exit_state() -> void:
	set_process(false)

func _process(delta):
	var aim_at_point = _get_aim_at_point()
	if not aim_at_point == Vector3.INF and not aim_at_point == null:
		face_target_y.face_point(aim_at_point, delta)
		face_target_x.face_point(aim_at_point, delta)
	
	if current_actor.is_stunned:
		state_transition.emit(self, "EnemyStunnedState")

func _shovel_snow() -> void:
	animation_player.play("shovel_attack")
	await animation_player.animation_finished
	current_actor.is_attacking = false
	state_transition.emit(self, "EnemyChaseState")

func _throw_snowball():
	animation_player.play("throw_attack")
	await get_tree().create_timer(0.6, false).timeout
	
	var _snowball = Snowball.instantiate()
	_snowball.attacking_actor = "enemy"
	get_tree().get_root().add_child(_snowball)
	_snowball.global_transform = fire_point.global_transform
	
	current_actor.current_snowball_count -= 1
	_snowball.setup(speedy)
	await animation_player.animation_finished
	current_actor.is_attacking = false
	if current_actor.current_snowball_count <= 0:
		state_transition.emit(self, "EnemyReloadState")
	else:
		state_transition.emit(self, "EnemyChaseState")
	

func _get_aim_at_point():
	var projectile_start_pos = snowball_throw_spot.global_transform.origin
	var target_start_pos = current_actor.player.global_transform.origin
	var target_velocity = current_actor.player.velocity
	var target_future_pos = target_start_pos
	var final_angle = 0.0
	for i in range(NUM_OF_ITERATIONS):
		var dist_to_target = projectile_start_pos.distance_to(target_future_pos)
		var target_height = target_future_pos.y - projectile_start_pos.y
		var angle = _get_angle_to_target_point(dist_to_target, target_height, speedy, gravity)
		if angle == null:
			current_actor.is_attacking = false
			return Vector3.INF
		var time_in_air = dist_to_target / (cos(angle) * speedy)
		
		target_future_pos = target_start_pos + target_velocity * time_in_air
		final_angle = angle
	
	var temp_vector = target_future_pos - projectile_start_pos
	var y_rotation = atan2(-temp_vector.x, -temp_vector.z)
	var predictive_dir = Vector3.FORWARD.rotated(Vector3.RIGHT, final_angle).rotated(Vector3.UP, y_rotation)
	return projectile_start_pos + predictive_dir * 20.0

func _get_angle_to_target_point(distance, height, SPEED, GRAVITY):
	# Set Gravity small number 0 might crash the game (atleast thats what I heard)
	if GRAVITY == 0:
		GRAVITY = 0.001
	
	# The equation: atan(SPEED^2 +- sqrt((SPEED^4 - Gravity(GRAVITY distance^2 + 25^2height))) / GRAVITYdistance
	var root = (SPEED * SPEED * SPEED * SPEED) - GRAVITY * (GRAVITY * distance * distance + 2.0 * height * SPEED * SPEED)
	
	# Out of range
	if root < 0.0:
		return null
	
	root = sqrt(root)
	var sub = GRAVITY * distance
	var s_sq = SPEED * SPEED
	var angle_optimal = atan((s_sq - root) / sub)
	var angle_long = atan((s_sq + root) / sub)
	
	return min(angle_optimal, angle_long)
