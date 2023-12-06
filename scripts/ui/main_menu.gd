extends Control

@onready var main_buttons = $MainButtons
@onready var options = $Options
@onready var difficulty = $Difficulty

@onready var difficulty_explanation_label = $"Difficulty/VBoxContainer/Difficulty explanation/DifficultyExplanationLabel"
@onready var delete_save_button = $MainButtons/VBoxContainer/Play/DeleteSaveButton
@onready var play_label = $MainButtons/VBoxContainer/Play/Label

@onready var logo = $Logo

@onready var audio_control = $AudioControl
@onready var audio_buttons = $Buttons

var skip_intro : bool
var disable_tutorials : bool

func _ready() -> void:
	if SaveManager.SAVE_PATH == null:
			play_label.text = "Play"
			delete_save_button.visible = false
	else:
		var save : = ConfigFile.new()
		save.load(SaveManager.SAVE_PATH)
		
		if not save.has_section("save"):
			play_label.text = "Play"
			delete_save_button.visible = false
		else:
			play_label.text = "Continue"
			delete_save_button.visible = true


func _on_options_pressed():
	audio_control.play_click_sound()
	main_buttons.visible = false
	options.visible = true
	logo.visible = false

func _on_exit_options_menu_pressed():
	audio_control.play_click_sound()
	main_buttons.visible = true
	options.visible = false
	logo.visible = true

func _on_credits_pressed():
	audio_control.play_click_sound()
	pass # Replace with function body.

func _on_quit_pressed():
	audio_control.play_click_sound()
	await audio_buttons.finished
	get_tree().quit()

func _on_play_pressed():
	audio_control.play_click_sound()
	logo.visible = false
	if SaveManager.SAVE_PATH == null:
		main_buttons.visible = false
		difficulty.visible = true
	else:
		var save : = ConfigFile.new()
		save.load(SaveManager.SAVE_PATH)
		
		if save.has_section("save"):
			await audio_buttons.finished
			LevelManager.load_level()
		else:
			main_buttons.visible = false
			difficulty.visible = true


func _on_exit_difficulty_menu_pressed():
	audio_control.play_click_sound()
	main_buttons.visible = true
	difficulty.visible = false
	logo.visible = true

# Epic hardcoded text stuff
func _on_normal_mouse_entered():
	difficulty_explanation_label.text = "Normal:
- Restore energy between levels!
- Your save is safe!"

func _on_hardcore_mouse_entered():
	difficulty_explanation_label.text = "Hardcore:
- Restore energy between levels!
- Save is deleted upon knockout!"

func _on_super_hardcore_mouse_entered():
	difficulty_explanation_label.text = "Super Hardcore:
- No energy restored between levels!
- Save is deleted upon knockout!"

# Difficulty buttons
func _on_normal_pressed():
	audio_control.play_click_sound()
	await audio_buttons.finished
	SaveManager.save_savefile("normal", 1, SaveManager.player_max_energy)
	LevelManager.load_first_level(skip_intro, disable_tutorials)

func _on_hardcore_pressed():
	audio_control.play_click_sound()
	await audio_buttons.finished
	SaveManager.save_savefile("hardcore", 1, SaveManager.player_max_energy)
	LevelManager.load_first_level(skip_intro, disable_tutorials)

func _on_super_hardcore_pressed():
	audio_control.play_click_sound()
	await audio_buttons.finished
	SaveManager.save_savefile("super_hardcore", 1, SaveManager.player_max_energy)
	LevelManager.load_first_level(skip_intro, disable_tutorials)

# Delete save
func _on_delete_save_button_pressed():
	audio_control.play_click_sound()
	SaveManager.clear_savefile()
	play_label.text = "Play"
	delete_save_button.visible = false

func _on_skip_intro_toggled(button_pressed):
	audio_control.play_click_sound()
	if button_pressed:
		skip_intro = true
	else:
		skip_intro = false

func _on_disable_tutorials_toggled(button_pressed):
	audio_control.play_click_sound()
	if button_pressed:
		disable_tutorials = true
	else:
		disable_tutorials = false
