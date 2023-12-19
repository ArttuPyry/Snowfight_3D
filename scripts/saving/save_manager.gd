extends Node

const SAVE_PATH := "user://save.tres"
const TIME_PATH := "user://time.tres"

var player_max_energy = 30

func save_savefile(difficulty, level, energy) -> void:
	var save : = ConfigFile.new()
	save.load(SAVE_PATH)
	
	save.set_value("save", "difficulty", difficulty)
	save.set_value("save", "level", level)
	
	# Max HP every level unless super hardcore difficulty
	if difficulty == "normal" or difficulty == "hardcore":
		save.set_value("save", "energy", player_max_energy)
	else:
		save.set_value("save", "energy", energy)
	
	save.save(SAVE_PATH)

func load_savefile() -> void:
	pass

func clear_savefile() -> void:
	var save : = ConfigFile.new()
	save.load(SAVE_PATH)
	save.clear()
	save.set_value("save", "difficulty", null)
	save.save(SAVE_PATH)

func save_time(msec, sec, mins) -> void:
	var time : = ConfigFile.new()
	time.load(TIME_PATH)
	
	var mseconds = msec + time.get_value("time", "mseconds", 0.0)
	var seconds = sec + time.get_value("time", "seconds", 0.0)
	var minutes = mins + time.get_value("time", "minutes", 0.0)
	
	if mseconds > 999:
		mseconds -= 1000
		seconds += 1
	
	if seconds > 59:
		seconds -= 70
		minutes += 1
	
	time.set_value("time", "mseconds", mseconds)
	time.set_value("time", "seconds", seconds)
	time.set_value("time", "minutes", minutes)
	
	time.save(TIME_PATH)

func clear_timefile() -> void:
	var time : = ConfigFile.new()
	time.load(TIME_PATH)
	time.clear()
	time.save(TIME_PATH)
