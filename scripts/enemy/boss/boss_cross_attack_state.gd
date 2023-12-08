class_name BossCrossAttackState
extends EnemyState

@export var fire_spots_behind : Array[Node3D]
@export var fire_spots_right : Array[Node3D]
@export var fire_spots_left : Array[Node3D]
@export var fire_spots_front : Array[Node3D]

@onready var animation_player = $"../../AnimationPlayer"

const snowball_no_grav = preload("res://weapons and ammo/snowball_cb_no_gravity.tscn")

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	animation_player.play("throw_attack")
	
	for i in fire_spots_behind.size():
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_behind[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	animation_player.play("throw_attack")
	
	for i in fire_spots_right.size():
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_right[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	animation_player.play("throw_attack")
	
	for i in fire_spots_left.size():
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_left[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	animation_player.play("throw_attack")
	
	for i in fire_spots_front.size():
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots_front[i].global_transform
		_snowball.setup(10.0)
	
	await get_tree().create_timer(2, false).timeout
	state_transition.emit(self, "BossStunnedState")
