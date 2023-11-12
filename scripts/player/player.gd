extends CharacterBody3D

@onready var user_interface = $"../UserInterface"
@onready var crosshair = $"../UserInterface/CenterContainer/Crosshair"

@export_category("Player stats")
@export var max_energy : int = 20
@export var max_snowball_count : int = 9

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
