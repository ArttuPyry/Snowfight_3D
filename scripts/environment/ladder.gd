extends Node3D

@onready var ladder_collision = $ForPlayer

@onready var ladder_bottom = $LadderBottom
@onready var ladder_top = $LadderTop

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_ladder_top_body_entered(body):
	if body.is_in_group("player"):
		player.ladder_position = ladder_top.global_position
		player.ladder_look_at = ladder_collision.global_position

func _on_ladder_top_body_exited(body):
	if body.is_in_group("player"):
		player.ladder_position = null
		player.ladder_look_at = null

func _on_ladder_bottom_body_entered(body):
	if body.is_in_group("player"):
		player.ladder_position = ladder_bottom.global_position
		player.ladder_look_at = ladder_collision.global_position

func _on_ladder_bottom_body_exited(body):
	if body.is_in_group("player"):
		player.ladder_position = null
		player.ladder_look_at = null
