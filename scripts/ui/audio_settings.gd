extends TabBar

@export_enum("Master", "Music", "SoundEffect", "Enivorment") var bus_name : String

var bus_index : int = 0

const CONFIG_SAVE_PATH := "user://useraudiopreferences.cfg"

var temp_master_index
@onready var master_slider = $Master/MasterSlider
@onready var cur_master_label = $Master/CurMasterLabel

var temp_music_index
@onready var music_slider = $MusicVolume/MusicSlider
@onready var cur_music_label = $MusicVolume/CurMusicLabel

var temp_effect_index
@onready var effect_slider = $EffectVolume/EffectSlider
@onready var cur_effect_label = $EffectVolume/CurEffectLabel

var temp_eniv_index
@onready var environment_slider = $EnvironmentVolume/EnvironmentSlider
@onready var cur_environment_label = $EnvironmentVolume/CurEnvironmentLabel

@onready var audio_control = $"../../../../AudioControl"

func _save_audio_preferences(master, music, effect, environment) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	config.set_value("audio_preferences", "master", master)
	config.set_value("audio_preferences", "music", music)
	config.set_value("audio_preferences", "effect", effect)
	config.set_value("audio_preferences", "environment", environment)
	
	config.save(CONFIG_SAVE_PATH)

func _load_audio_preferences(section):
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	var ma = config.get_value(section, "master", 0.5)
	var mu = config.get_value(section, "music", 0.5)
	var ef = config.get_value(section, "effect", 0.5)
	var en = config.get_value(section, "environment", 0.5)
	
	if not ma == null:
		AudioServer.set_bus_volume_db(0, linear_to_db(ma))
		cur_master_label.text = str(ma * 100)
		master_slider.set_value_no_signal(ma * 100)
	
	if not mu == null:
		AudioServer.set_bus_volume_db(1, linear_to_db(mu))
		cur_music_label.text = str(mu * 100)
		music_slider.set_value_no_signal(mu * 100)
	
	if not ef == null:
		AudioServer.set_bus_volume_db(2, linear_to_db(ef))
		cur_effect_label.text = str(ef * 100)
		effect_slider.set_value_no_signal(ef * 100)
	
	if not en == null:
		AudioServer.set_bus_volume_db(3, linear_to_db(en))
		cur_environment_label.text = str(en * 100)
		environment_slider.set_value_no_signal(en * 100)

func _clear_audio_preferences():
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	config.clear()
	config.save(CONFIG_SAVE_PATH)

func _ready():
	_load_audio_preferences("audio_preferences")

func _on_save_sound_settings_button_pressed():
	audio_control.play_click_sound()
	_save_audio_preferences(temp_master_index, temp_music_index, temp_effect_index, temp_eniv_index)

func _on_clear_sound_settings_button_pressed():
	audio_control.play_click_sound()
	_clear_audio_preferences()

func _on_master_slider_value_changed(value):
	temp_master_index = value / 100
	AudioServer.set_bus_volume_db(0, linear_to_db(temp_master_index))
	cur_master_label.text = str(value)

func _on_music_slider_value_changed(value):
	temp_music_index = value / 100
	AudioServer.set_bus_volume_db(1, linear_to_db(temp_music_index))
	cur_music_label.text = str(value)

func _on_effect_slider_value_changed(value):
	temp_effect_index = value / 100
	AudioServer.set_bus_volume_db(2, linear_to_db(temp_effect_index))
	cur_effect_label.text = str(value)

func _on_environment_slider_value_changed(value):
	temp_eniv_index = value / 100
	AudioServer.set_bus_volume_db(3, linear_to_db(temp_eniv_index))
	cur_environment_label.text = str(value)

func _on_save_sound_settings_button_mouse_entered():
	audio_control.play_hover_sound()

func _on_clear_sound_settings_button_mouse_entered():
	audio_control.play_hover_sound()
