class_name HitboxComponent
extends Area3D

var damage
var attacking_actor
@onready var snowball = $".."

func _ready():
	attacking_actor = snowball.attacking_actor
	damage = snowball.damage

func _init() -> void:
	collision_layer = 8
	collision_mask = 0
