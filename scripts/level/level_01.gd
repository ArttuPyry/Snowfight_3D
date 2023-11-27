extends Node3D

func _ready():
	if LevelManager.tutorials_disabled:
		print("DISABLE")
	else:
		print("enable")

