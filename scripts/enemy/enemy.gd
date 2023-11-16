extends CharacterBody3D

@export_category("Enemy stats")
@export var max_energy : int = 5
@export var max_snowball_count : int = 3
var current_snowball_count : int
@export var vision_arc = 60.0
@export var speed = 2.0
@export var attack_range = 2.5

var is_stunned = false

@export_category("Enemy patrolling and chasing")
var seen_player : bool = false
@export var enemy_patrol_waypoints : Array[Node3D]
@export var patrolling : bool
@export var player_path : NodePath
@export var player : Node3D

enum AttackType {snowball, shovel}
@export var attack_type  :  AttackType

func _ready() -> void:
	current_snowball_count = max_snowball_count

func target_in_range() -> bool:
	return self.global_position.distance_to(player.global_position) < attack_range

func no_health() -> void:
	is_stunned = true
