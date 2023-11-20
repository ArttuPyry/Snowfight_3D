extends Node3D

@onready var down = $down
@onready var up = $Up
@onready var loook = $MeshInstance3D

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_up_body_entered(body):
	if body.is_in_group("player"):
		player.teste = up.global_position
		player.look = loook.global_position

func _on_up_body_exited(body):
	if body.is_in_group("player"):
		player.teste = null
		player.look = null

func _on_down_body_entered(body):
	if body.is_in_group("player"):
		player.teste = down.global_position
		player.look = loook.global_position

func _on_down_body_exited(body):
	if body.is_in_group("player"):
		player.teste = null
		player.look = null
