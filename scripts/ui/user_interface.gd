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


var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.crosshair = crosshair

func setup_ui(max_energy, energy, ammo_c) -> void:
	energy_bar.value = energy
	energy_bar.max_value = max_energy
	max_ammo.text = str(ammo_c)
	current_ammo.text = str(ammo_c)

func update_energy(damage) -> void:
	energy_bar.value -= damage

func update_ammo() -> void:
	current_ammo.text = str(player.current_snowball_count)

func you_lost() -> void:
	lost_panel.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false
	
	var save : = ConfigFile.new()
	save.load(SaveManager.SAVE_PATH)
	
	var difficulty = save.get_value("save", "difficulty", null)
	
	if difficulty == "normal":
		retry.visible = true
	else: 
		SaveManager.clear_savefile()
		retry.visible = false

func open_pause_menu() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	energy_bar.visible = false
	ammo.visible = false
	crosshair.visible = false

func _on_continue_pressed():
	get_tree().paused = false
	pause_menu.visible = false
	energy_bar.visible = true
	ammo.visible = true
	crosshair.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_options_pressed() -> void:
	options.visible = true
	main_buttons.visible = false
	set_process(true)

func _on_exit_options_menu_pressed() -> void:
	options.visible = false
	main_buttons.visible = true

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
