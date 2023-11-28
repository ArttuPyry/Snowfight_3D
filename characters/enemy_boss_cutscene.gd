extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	await get_tree().create_timer(8.9, false).timeout
	animation_player.play("throw_attack")
