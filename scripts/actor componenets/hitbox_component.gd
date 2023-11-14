class_name HitboxComponent
extends Area3D

var damage
var attacking_actor
@export var attack : Node3D

func _ready():
	attacking_actor = attack.attacking_actor
	damage = attack.damage

func _init() -> void:
	collision_layer = 8
	collision_mask = 0
