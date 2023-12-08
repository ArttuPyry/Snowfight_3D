extends Area3D

var ui

@onready var donut = $Donut

@onready var boss_music = preload("res://sounds/music/boss_josefpres.mp3")

func _ready():
	donut.visible = false
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
			
			if level == 6:
				var enemies = get_tree().get_nodes_in_group("enemy")
				var animation_player = get_tree().get_first_node_in_group("animation_player_lvl6")
				var audio_music = get_tree().get_first_node_in_group("music_lvl6")
				
				for i in enemies.size():
					enemies[i].queue_free()
				
				animation_player.play("boss_cutscene")
				audio_music.stop()
				audio_music.stream = boss_music
				audio_music.play()
				ui.mission_boss_update()
			else:
				level += 1
				SaveManager.save_savefile(difficulty, level, energy)
				ui.open_victory_screen()

func _process(delta):
	donut.rotate_y(1 * delta)
