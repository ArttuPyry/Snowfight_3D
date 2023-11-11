extends CharacterBody3D

@onready var user_interface = $"../UserInterface"
@onready var crosshair = $"../UserInterface/CenterContainer/Crosshair"

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
