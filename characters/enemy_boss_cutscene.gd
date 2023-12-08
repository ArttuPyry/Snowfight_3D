extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")
	await get_tree().create_timer(12.2, false).timeout
	animation_player.play("throw_attack")


func _on_visibility_changed():
	animation_player.play("idle")
	await get_tree().create_timer(7.3, false).timeout
	animation_player.play("throw_attack")
