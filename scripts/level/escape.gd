extends Area3D

var ui

func _ready():
	ui = get_tree().get_first_node_in_group("ui")

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.mission_completed:
			var save : = ConfigFile.new()
			save.load(SaveManager.SAVE_PATH)
			
			var difficulty = save.get_value("save", "difficulty")
			var level = save.get_value("save", "level")
			var energy
			if difficulty == "normal" or difficulty == "hardcore":
				energy = SaveManager.player_max_energy
			else:
				energy = body.current_health
			
			level += 1
			
			SaveManager.save_savefile(difficulty, level, energy)
			ui.open_victory_screen()
