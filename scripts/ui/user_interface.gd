extends Control

@onready var crosshair = $CenterContainer/Crosshair

@onready var max_ammo = $Ammo/Max
@onready var current_ammo = $Ammo/Current
@onready var energy_bar = $Energy/EnergyBar
@onready var lost_panel = $LostPanel
@onready var options = $Options
@onready var main_buttons = $PauseMenu/MainButtons
@onready var pause_menu = $PauseMenu
@onready var ammo = $Ammo
@onready var retry = $LostPanel/VBoxContainer2/VBoxContainer/Retry
@onready var obj = $Objectives/VBoxContainer/PanelContainer/VBoxContainer/obj
@onready var amount = $Objectives/VBoxContainer/PanelContainer/VBoxContainer/amount
@onready var objectives = $Objectives

@onready var boss_energy = $BossEnergy
@onready var boss_energy_bar = $BossEnergy/EnergyBar


# Timer
@onready var min_label = $Objectives/VBoxContainer/HBoxContainer/Min
@onready var sec_label = $Objectives/VBoxContainer/HBoxContainer/Sec
@onready var msec_label = $Objectives/VBoxContainer/HBoxContainer/Msec

# Victory
@onready var win_panel = $WinPanel
@onready var level_time = $WinPanel/VBoxContainer/LevelTime
@onready var level_completed = $WinPanel/VBoxContainer/LevelCompleted
@onready var game_time = $WinPanel/VBoxContainer/GameTime
@onready var next_level = $WinPanel/VBoxContainer/VBoxContainer/NextLevel
var escape

# Audio
@onready var audio_buttons = $Buttons
@onready var audio_control = $AudioControl
@onready var audio_victory = $Victory
@onready var audio_lose = $Lose
@onready var audio_chime = $Chime

# Animation
@onready var animation_player = $AnimationPlayer

var time : float = 0.0
var minutes : int = 0
var seconds : int = 0
var mseconds : int = 0

var player

func _ready() -> void:
	escape = get_tree().get_first_node_in_group("escape")
	player = get_tree().get_first_node_in_group("player")
	player.crosshair = crosshair

func _process(delta) -> void:
	time += delta
	mseconds = fmod(time, 1) * 1000
	seconds = fmod(time, 60)
	minutes = fmod(time, 60 * 60) / 60
	min_label.text = "%02d:" % minutes
	sec_label.text = "%02d." % seconds
	msec_label.text = "%03d" % mseconds

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, mseconds]

func setup_ui(max_energy, energy, ammo_c) -> void:
	energy_bar.value = energy
	energy_bar.max_value = max_energy
	max_ammo.text = str(ammo_c)
	current_ammo.text = str(ammo_c)
	amount.text = "Snowmen left: " + str(player.snowmen)

func update_mission() -> void:
	if player.snowmen > 0:
		amount.text = "Snowmen left: " + str(player.snowmen)
	else:
		await get_tree().create_timer(0.5, false).timeout
		amount.visible = false
		audio_chime.play()
		escape.donut.visible = true
		obj.add_theme_color_override("font_color", Color.YELLOW)
		obj.text = "Escape!"

func update_energy(damage) -> void:
	energy_bar.value -= damage
	
	if animation_player.is_playing():
		animation_player.stop()
		animation_player.play("player_hit")
	else:
		animation_player.play("player_hit")

func update_ammo() -> void:
	current_ammo.text = str(player.current_snowball_count)

func you_lost() -> void:
	lost_panel.visible = true
	get_tree().paused = true
	audio_lose.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false
	objectives.visible = false
	
	var save : = ConfigFile.new()
	save.load(SaveManager.SAVE_PATH)
	
	var difficulty = save.get_value("save", "difficulty", null)
	
	if difficulty == "normal":
		retry.visible = true
	else: 
		SaveManager.clear_savefile()
		retry.visible = false

func open_victory_screen() -> void:
	win_panel.visible = true
	get_tree().paused = true
	audio_victory.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false
	objectives.visible = false
	level_time.text = "Time: " + get_time_formatted()
	level_completed.text = "Level Completed!"
	SaveManager.save_time(mseconds, seconds, minutes)

func _on_next_level_pressed():
	get_tree().paused = false
	audio_control.play_click_sound()
	await audio_buttons.finished
	LevelManager.load_level()

func open_pause_menu() -> void:
	get_tree().paused = true
	audio_control.play_click_sound()
	pause_menu.visible = true
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false
	objectives.visible = false

func _on_continue_pressed():
	audio_control.play_click_sound()
	get_tree().paused = false
	pause_menu.visible = false
	energy_bar.visible = true
	ammo.visible = true
	crosshair.visible = true
	objectives.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_options_pressed() -> void:
	audio_control.play_click_sound()
	options.visible = true
	main_buttons.visible = false
	set_process(true)

func _on_exit_options_menu_pressed() -> void:
	audio_control.play_click_sound()
	player.load_user_config()
	options.visible = false
	main_buttons.visible = true

func _on_quit_pressed() -> void:
	get_tree().paused = false
	audio_control.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_pressed():
	get_tree().paused = false
	audio_control.play_click_sound()
	await audio_buttons.finished
	LevelManager.load_level()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func enable_boss_health(energy) -> void:
	boss_energy_bar.max_value = energy
	boss_energy_bar.value = energy
	boss_energy.visible = true

func update_boss_energy(damage) -> void:
	boss_energy_bar.value -= damage

func mission_boss_update() -> void:
	audio_chime.play()
	obj.add_theme_color_override("font_color", Color.RED)
	obj.text = "Defeat bully!"

func boss_defeated() -> void:
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false
	objectives.visible = false
	boss_energy.visible = false
	
	await get_tree().create_timer(6, false).timeout
	
	win_panel.visible = true
	game_time.visible = true
	get_tree().paused = true
	
	next_level.visible = false
	
	audio_victory.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	level_time.text = "Time: " + get_time_formatted()
	level_completed.text = "Level Completed!
	Thank you for playing!"
	SaveManager.save_time(mseconds, seconds, minutes)
	
	SaveManager.clear_savefile()
