extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player.play("intro")
	await animation_player.animation_finished
	LevelManager.load_level()

	
