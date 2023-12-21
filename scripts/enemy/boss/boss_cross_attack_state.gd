class_name BossCrossAttackState
extends EnemyState

@export var fire_spots_behind : Array[Node3D]
@export var fire_spots_right : Array[Node3D]
@export var fire_spots_left : Array[Node3D]
@export var fire_spots_front : Array[Node3D]

@onready var throw_behind = $"../../Behind/Throw"
@onready var throw_left = $"../../Left/Throw"
@onready var throw_right = $"../../Right/Throw"
@onready var throw_front = $"../../Front/Throw"

@onready var look_at_behind = $"../../Behind/LookAt"
@onready var look_at_left = $"../../Left/LookAt"
@onready var look_at_right = $"../../Right/LookAt"
@onready var look_at_front = $"../../Front/LookAt"

@onready var warning_behind = $"../../Behind/Warning"
@onready var warning_left = $"../../Left/Warning"
@onready var warning_right = $"../../Right/Warning"
@onready var warning_front = $"../../Front/Warning"

@onready var throw = $"../../Throw"

@onready var animation_player = $"../../AnimationPlayer"

const snowball_no_grav = preload("res://weapons and ammo/snowball_cb_no_gravity.tscn")

@onready var enemy_boss = $"../.."

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	enemy_boss.look_at(Vector3(look_at_behind.global_position.x, enemy_boss.global_position.y, look_at_behind.global_position.z), Vector3.UP)
	animation_player.play("throw_attack")
	warning_behind.visible = true
	throw.play()
	await get_tree().create_timer(1, false).timeout
	warning_behind.visible = false
	
	for i in fire_spots_behind.size():
		throw_behind.play()
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_behind[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	enemy_boss.look_at(Vector3(look_at_right.global_position.x, enemy_boss.global_position.y, look_at_right.global_position.z), Vector3.UP)
	animation_player.play("throw_attack")
	warning_right.visible = true
	throw.play()
	await get_tree().create_timer(1, false).timeout
	warning_right.visible = false
	
	for i in fire_spots_right.size():
		throw_right.play()
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_right[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	enemy_boss.look_at(Vector3(look_at_front.global_position.x, enemy_boss.global_position.y, look_at_front.global_position.z), Vector3.UP)
	animation_player.play("throw_attack")
	warning_front.visible = true
	throw.play()
	await get_tree().create_timer(1, false).timeout
	warning_front.visible = false
	
	for i in fire_spots_front.size():
		throw_front.play()
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_front[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	enemy_boss.look_at(Vector3(look_at_left.global_position.x, enemy_boss.global_position.y, look_at_left.global_position.z), Vector3.UP)
	animation_player.play("throw_attack")
	warning_left.visible = true
	throw.play()
	await get_tree().create_timer(1, false).timeout
	warning_left.visible = false
	
	for i in fire_spots_left.size():
		throw_left.play()
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_left[i].global_transform
		_snowball.setup(10.0)
		
	
	await get_tree().create_timer(2, false).timeout
	state_transition.emit(self, "BossStunnedState")
