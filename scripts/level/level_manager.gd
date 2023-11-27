extends Node

var tutorials_disabled : bool = true

func load_first_level(skip_intro, disable_tutorials) -> void:
	if skip_intro:
		tutorials_disabled = disable_tutorials
		get_tree().change_scene_to_file("res://scenes/level_01.tscn")
	else:
		tutorials_disabled = disable_tutorials
		get_tree().change_scene_to_file("res://scenes/level_00.tscn")

func load_next_level() -> void:
	get_tree().change_scene_to_file("res://scenes/level_" + "0" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
