extends CharacterBody3D

@onready var user_interface = $"../UserInterface"

@export var max_energy : int = 24
var seen_player = true
var enabled = false

func update_health_bar(damage) -> void:
	user_interface.update_boss_energy(damage)

func no_health() -> void:
	var animation_player = get_tree().get_first_node_in_group("animation_player_lvl6")
	animation_player.play("victory")
	user_interface.boss_defeated()
	self.queue_free()

func _on_visibility_changed():
	enabled = true
	user_interface.enable_boss_health(max_energy)
