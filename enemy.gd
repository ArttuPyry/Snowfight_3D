extends CharacterBody3D

@export_category("Enemy stats")
@export var max_energy : int = 5
@export var max_snowball_count : int = 3
@export var vision_arc = 60.0

var seen_player : bool
@export var is_patrolling : bool
@export var current_target : Node3D
