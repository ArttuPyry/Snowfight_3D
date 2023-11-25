extends TabBar

@onready var mouse_controlled_camera_box = $MouseControlledCamera/MouseControlledCameraBox
@onready var leading_crosshair_box = $LeadingCrosshair/LeadingCrosshairBox
@onready var field_of_view_slider = $FieldOfView/FieldOfViewSlider
@onready var cur_field_of_view_label = $FieldOfView/CurFieldOfViewLabel


var temp_mouse_bool
var temp_leading_bool
var temp_fov_index

const CONFIG_SAVE_PATH := "user://usergameplaypreferences.tres"

func _ready():
	_load_gameplay_preferences("gameplay_preferences")

func _on_save_gameplay_settings_button_pressed():
	_save_gameplay_preferences(temp_mouse_bool, temp_leading_bool, temp_fov_index)

func _on_clear_gameplay_settings_button_pressed():
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	config.clear()
	config.save(CONFIG_SAVE_PATH)

func _save_gameplay_preferences(mouse_bool, leading_bool, fov_index) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	config.set_value("gameplay_preferences", "mouse_bool", mouse_bool)
	config.set_value("gameplay_preferences", "leading_bool", leading_bool)
	config.set_value("gameplay_preferences", "fov_index", fov_index)
	
	config.save(CONFIG_SAVE_PATH)

func _load_gameplay_preferences(section) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	var mouse = config.get_value(section, "mouse_bool", false)
	var leading = config.get_value(section, "leading_bool", false)
	var fov = config.get_value(section, "fov_index", 75)
	
	if mouse:
		mouse_controlled_camera_box.set_pressed_no_signal(true)
	else:
		mouse_controlled_camera_box.set_pressed_no_signal(false)
	
	if leading:
		leading_crosshair_box.set_pressed_no_signal(true)
	else:
		leading_crosshair_box.set_pressed_no_signal(false)
	
	field_of_view_slider.set_value_no_signal(fov)
	cur_field_of_view_label.text = str(fov)

func _on_mouse_controlled_camera_box_toggled(button_pressed):
	if button_pressed:
		temp_mouse_bool = true
	else: 
		temp_mouse_bool = false

func _on_leading_crosshair_box_toggled(button_pressed):
	if button_pressed:
		temp_leading_bool = true
	else: 
		temp_leading_bool = false

func _on_field_of_view_slider_value_changed(value):
	cur_field_of_view_label.text = str(field_of_view_slider.value)

func _on_field_of_view_slider_drag_ended(value_changed):
	temp_fov_index = field_of_view_slider.value
