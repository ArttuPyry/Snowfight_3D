extends Node3D

var player

@onready var snowman = $Snowman
@onready var destroy_spot = $DestroySpot

func _ready():
	player = get_tree().get_first_node_in_group("player")

# Send needed info
func _on_destroy_spot_body_entered(body):
	if body.is_in_group("player"):
		player.interactable = destroy_spot
		player.interactable_group = "snowman"
		player.interact_look_at = snowman.global_position

# Remove info
func _on_destroy_spot_body_exited(body):
	if body.is_in_group("player"):
		player.interactable = null
		player.interactable_group = null
		player.interact_look_at = null
