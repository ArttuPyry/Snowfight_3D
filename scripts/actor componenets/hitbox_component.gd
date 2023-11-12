class_name HitboxComponent
extends Area3D

var damage
@onready var snowball = $".."

func _ready():
	damage = snowball.damage

func _init() -> void:
	collision_layer = 8
	collision_mask = 0
