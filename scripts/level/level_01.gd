extends Node3D

func _ready():
	SaveManager.clear_timefile()
	
	if LevelManager.tutorials_disabled:
		print("DISABLE")
	else:
		print("enable")

