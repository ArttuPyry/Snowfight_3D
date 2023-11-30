extends Area3D

@onready var snowman = $"../Snowman"
@onready var snowman_destroyed = $"../snowman_destroyed"
@onready var snow_splashes = $"../SnowSplashes"
@onready var animation_player = $"../AnimationPlayer"

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func play_snow_splash() -> void:
	animation_player.play("destroy")

func swap_to_destroyed() -> void:
	snowman.visible = false
	snowman_destroyed.visible = true
	self.queue_free()
	player.snowman_destroyed()
