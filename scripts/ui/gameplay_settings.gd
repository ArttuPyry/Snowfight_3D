extends TabBar

@onready var mouse_controlled_camera_box = $MouseControlledCamera/MouseControlledCameraBox
@onready var leading_crosshair_box = $LeadingCrosshair/LeadingCrosshairBox
@onready var field_of_view_slider = $FieldOfView/FieldOfViewSlider
@onready var cur_field_of_view_label = $FieldOfView/CurFieldOfViewLabel

@onready var keyboard_horizontal_sens_slider = $KeyboardHorizontalSens/KeyboardHorizontalSensSlider
@onready var cur_keyboard_horizontal_sens_label = $KeyboardHorizontalSens/CurKeyboardHorizontalSensLabel
@onready var keyboard_vertical_sens_slider = $KeyboardVerticalSens/KeyboardVerticalSensSlider
@onready var cur_keyboard_vertical_sens_label = $KeyboardVerticalSens/CurKeyboardVerticalSensLabel

@onready var mouse_horizontal_sens_slider = $MouseHorizontalSens/MouseHorizontalSensSlider
@onready var cur_mouse_horizontal_sens_label = $MouseHorizontalSens/CurMouseHorizontalSensLabel
@onready var mouse_vertical_sens_slider = $MouseVerticalSens/MouseVerticalSensSlider
@onready var cur_mouse_vertical_sens_label = $MouseVerticalSens/CurMouseVerticalSensLabel

@onready var audio_control = $"../../../../AudioControl"

# Saving
const CONFIG_SAVE_PATH := "user://usergameplaypreferences.cfg"
var temp_mouse_bool
var temp_leading_bool
var temp_fov_index
var temp_kb_hori_float
var temp_kb_vert_float
var temp_mouse_hori_float
var temp_mouse_vert_float

func _ready():
	_load_gameplay_preferences("gameplay_preferences")

func _on_save_gameplay_settings_button_pressed():
	audio_control.play_click_sound()
	_save_gameplay_preferences(temp_mouse_bool, temp_leading_bool, temp_fov_index, temp_kb_hori_float, temp_kb_vert_float, temp_mouse_hori_float, temp_mouse_vert_float)

func _on_clear_gameplay_settings_button_pressed():
	audio_control.play_click_sound()
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	config.clear()
	config.save(CONFIG_SAVE_PATH)

func _save_gameplay_preferences(mouse_bool, leading_bool, fov_index, kb_hori_float, kb_vert_float, mouse_hori_float, mouse_vert_float) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	config.set_value("gameplay_preferences", "mouse_bool", mouse_bool)
	config.set_value("gameplay_preferences", "leading_bool", leading_bool)
	config.set_value("gameplay_preferences", "fov_index", fov_index)
	config.set_value("gameplay_preferences", "kb_hori_float", kb_hori_float)
	config.set_value("gameplay_preferences", "kb_vert_float", kb_vert_float)
	config.set_value("gameplay_preferences", "mouse_hori_float", mouse_hori_float)
	config.set_value("gameplay_preferences", "mouse_vert_float", mouse_vert_float)
	
	config.save(CONFIG_SAVE_PATH)

func _load_gameplay_preferences(section) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	var mouse = config.get_value(section, "mouse_bool", false)
	var leading = config.get_value(section, "leading_bool", false)
	var fov = config.get_value(section, "fov_index", 75)
	var kb_h_sens = config.get_value(section, "kb_hori_float", 5)
	var kb_v_sens = config.get_value(section, "kb_vert_float", 5)
	var mouse_h_sens = config.get_value(section, "mouse_hori_float", 5)
	var mouse_v_sens = config.get_value(section, "mouse_vert_float", 5)
	
	if not mouse == null:
		if mouse == true:
			mouse_controlled_camera_box.set_pressed_no_signal(true)
			temp_mouse_bool = true
		else:
			mouse_controlled_camera_box.set_pressed_no_signal(false)
			temp_mouse_bool = false
	
	if not leading == null:
		if leading == true:
			leading_crosshair_box.set_pressed_no_signal(true)
			temp_leading_bool = true
		else:
			leading_crosshair_box.set_pressed_no_signal(false)
			temp_leading_bool = false
	
	if not fov == null:
		field_of_view_slider.set_value_no_signal(fov)
		cur_field_of_view_label.text = str(fov)
		temp_fov_index = fov
	
	if not kb_h_sens == null:
		keyboard_horizontal_sens_slider.set_value_no_signal(kb_h_sens)
		cur_keyboard_horizontal_sens_label.text = str(kb_h_sens)
		temp_kb_hori_float = kb_h_sens
	
	if not kb_v_sens == null:
		keyboard_vertical_sens_slider.set_value_no_signal(kb_v_sens)
		cur_keyboard_vertical_sens_label.text = str(kb_v_sens)
		temp_kb_vert_float = kb_v_sens
	
	if not mouse_h_sens == null:
		mouse_horizontal_sens_slider.set_value_no_signal(mouse_h_sens)
		cur_mouse_horizontal_sens_label.text = str(mouse_h_sens)
		temp_mouse_hori_float = mouse_h_sens
	
	if not mouse_v_sens == null:
		mouse_vertical_sens_slider.set_value_no_signal(mouse_v_sens)
		cur_mouse_vertical_sens_label.text = str(mouse_v_sens)
		temp_mouse_vert_float = mouse_v_sens

func _on_mouse_controlled_camera_box_toggled(button_pressed):
	audio_control.play_click_sound()
	if button_pressed:
		temp_mouse_bool = true
	else: 
		temp_mouse_bool = false

func _on_leading_crosshair_box_toggled(button_pressed):
	audio_control.play_click_sound()
	if button_pressed:
		temp_leading_bool = true
	else: 
		temp_leading_bool = false

# FOV
func _on_field_of_view_slider_value_changed(value):
	cur_field_of_view_label.text = str(field_of_view_slider.value)

func _on_field_of_view_slider_drag_ended(_value_changed):
	audio_control.play_click_sound()
	temp_fov_index = field_of_view_slider.value

# Keyboard Horizontal sensitivity
func _on_keyboard_horizontal_sens_slider_value_changed(value):
	cur_keyboard_horizontal_sens_label.text = str(keyboard_horizontal_sens_slider.value)

func _on_keyboard_horizontal_sens_slider_drag_ended(_value_changed):
	audio_control.play_click_sound()
	temp_kb_hori_float = keyboard_horizontal_sens_slider.value

# Keyboard Vertical sensitivity
func _on_keyboard_vertical_sens_slider_value_changed(value):
	cur_keyboard_vertical_sens_label.text = str(keyboard_vertical_sens_slider.value)

func _on_keyboard_vertical_sens_slider_drag_ended(_value_changed):
	audio_control.play_click_sound()
	temp_kb_vert_float = keyboard_vertical_sens_slider.value

# Mouse Horizontal sensitivity
func _on_mouse_horizontal_sens_slider_value_changed(value):
	cur_mouse_horizontal_sens_label.text = str(mouse_horizontal_sens_slider.value)

func _on_mouse_horizontal_sens_slider_drag_ended(_value_changed):
	audio_control.play_click_sound()
	temp_mouse_hori_float = mouse_horizontal_sens_slider.value

# Mouse Vertical sensitivity
func _on_mouse_vertical_sens_slider_value_changed(value):
	cur_mouse_vertical_sens_label.text = str(mouse_vertical_sens_slider.value)

func _on_mouse_vertical_sens_slider_drag_ended(_value_changed):
	audio_control.play_click_sound()
	temp_mouse_vert_float = mouse_vertical_sens_slider.value
