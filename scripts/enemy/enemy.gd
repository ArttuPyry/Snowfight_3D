extends CharacterBody3D

@export_category("Enemy look")
@export var skin : int = 0
@onready var enemy_mesh = $Armature/Skeleton3D/enemy

@export_category("Enemy stats")
@export var max_energy : int = 5
@export var max_snowball_count : int = 3
var current_snowball_count : int
@export var vision_arc = 90.0
@export var speed = 5.0
@export var attack_range = 2.5

var is_stunned = false

@export_category("Enemy patrolling and chasing")
var seen_player : bool = false
@export var enemy_patrol_waypoints : Array[Node3D]
@export var patrolling : bool
@export var player_path : NodePath
@export var player : Node3D

var is_attacking : bool = false

enum AttackType {snowball, shovel}
@export var attack_type  :  AttackType

# Preload skins
var skin00 = preload("res://characters/material00.tres")
var skin01 = preload("res://characters/material01.tres")
var skin02 = preload("res://characters/material02.tres")
var skin03 = preload("res://characters/material03.tres")
var skin04 = preload("res://characters/material04.tres")
var skin05 = preload("res://characters/material05.tres")

# Set skin
func _ready() -> void:
	current_snowball_count = max_snowball_count
	match skin:
		0:
			enemy_mesh.material_override = skin00
		1:
			enemy_mesh.material_override = skin01
		2:
			enemy_mesh.material_override = skin02
		3:
			enemy_mesh.material_override = skin03
		4:
			enemy_mesh.material_override = skin04
		5:
			enemy_mesh.material_override = skin05

# Check if player is in range
func target_in_range() -> bool:
	return self.global_position.distance_to(player.global_position) < attack_range

# Get stunned when no !ENERGY!!!
func no_health() -> void:
	is_stunned = true
