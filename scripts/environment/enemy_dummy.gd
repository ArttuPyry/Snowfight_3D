extends Node3D

@export_category("Enemy dummy look")
@export var randomize_skin : bool = false
@export var skin : int = 0
@onready var enemy_mesh = $Armature/Skeleton3D/enemy

@onready var animation_player = $AnimationPlayer

var skin00 = preload("res://characters/material00.tres")
var skin01 = preload("res://characters/material01.tres")
var skin02 = preload("res://characters/material02.tres")
var skin03 = preload("res://characters/material03.tres")
var skin04 = preload("res://characters/material04.tres")
var skin05 = preload("res://characters/material05.tres")

# This is for random skin
func _ready():
	if randomize_skin:
		randomize()
		var rng = RandomNumberGenerator.new()
		var random_skin = rng.randi_range(1, 6)
		match random_skin:
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
	else:
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
	
	animation_player.play("idle")
