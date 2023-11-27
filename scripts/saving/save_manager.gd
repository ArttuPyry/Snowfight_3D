extends Node


const SAVE_PATH := "user://save.tres"

var player_max_energy = 20

func save_savefile(difficulty, level, energy) -> void:
	var config : = ConfigFile.new()
	config.load(SAVE_PATH)
	
	config.set_value("save", "difficulty", difficulty)
	config.set_value("save", "level", level)
	
	# Max HP every level unless super hardcore difficulty
	if difficulty == "normal" or difficulty == "hardcore":
		config.set_value("save", "energy", player_max_energy)
	else:
		config.set_value("save", "energy", energy)
	
	config.save(SAVE_PATH)

func load_savefile() -> void:
	pass

func clear_savefile() -> void:
	var config : = ConfigFile.new()
	config.load(SAVE_PATH)
	config.clear()
	config.set_value("save", "difficulty", null)
	config.save(SAVE_PATH)
