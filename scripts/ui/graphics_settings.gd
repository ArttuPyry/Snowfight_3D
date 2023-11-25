extends TabBar

@onready var window_mode_button = $WindowMode/WindowModeButton
@onready var resolution_button = $Resolution/ResolutionButton
@onready var antialiasing_button = $Antialiasing/AntialiasingButton
@onready var v_sync_check_box = $VSync/VSyncCheckBox
@onready var fps_slider = $FPS/FPSSlider
@onready var cur_fps_label = $FPS/CurFPSLabel

# Saving settings
const CONFIG_SAVE_PATH := "user://usergraphicspreferences.tres"
var temp_wp_index
var temp_res_index
var temp_vsync_bool
var temp_aa_index
var temp_fps_index

const WINDOW_MODE_ARRAY : Array[String] = [
	"Fullscreen",
	"Window mode",
	"Borderless window",
	"Borderless fullscreen"
]

const RESOLUTION_DICTIONARY : Dictionary = {
#	"3840x2160 (16:9)":Vector2(3840, 2160),
#	"2560x1440  (16:9)":Vector2(2560, 1440),
#	"2048x1152 (16:9)":Vector2(2048, 1152),
#	"1920x1080 (16:9)":Vector2(1920, 1080),
#	"1280x720 (16:9)":Vector2(1280, 720),
#	"6404x360 (16:9)":Vector2(640, 360),
	"4096x3072 (4:3)":Vector2(4096, 3072),
	"3200x2400 (4:3)":Vector2(3200, 2400),
	"2048x1536 (4:3)":Vector2(2048, 1536),
	"1440x1080 (4:3)":Vector2(1440, 1080),
	"1024x768 (4:3)":Vector2(1024, 768),
	"800x600 (4:3)":Vector2(800,600)
}

const ANTIALIASING_ARRAY : Array[String] = [
	"Disabled",
	"MSAA: 2x",
	"MSAA: 4x",
	"MSAA: 8x"
]

############################## SAVE ###################################################

func _save_graphics_preferences(window_mode_index, resolution_index, vsync_bool,aa_index, fps_index) -> void:
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	config.set_value("graphics_preferences", "wm_index", window_mode_index)
	config.set_value("graphics_preferences", "res_index", resolution_index)
	config.set_value("graphics_preferences", "vsync_bool", vsync_bool)
	config.set_value("graphics_preferences", "aa_index", aa_index)
	config.set_value("graphics_preferences", "fps_index", fps_index)
	
	config.save(CONFIG_SAVE_PATH)

func _load_graphics_preferences(section):
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	
	var wm = config.get_value(section, "wm_index", 0)
	var res = config.get_value(section, "res_index", 0)
	var vsync = config.get_value(section, "vsync_bool", false)
	var aa = config.get_value(section, "aa_index", 0)
	var fps = config.get_value(section, "fps_index", 60)
	
	# WINDOW MODE
	if not wm == null:
		_on_window_mode_selected(wm)
		window_mode_button.set_text(WINDOW_MODE_ARRAY[wm])
	
	# RESOLUTION
	if not res == null:
		_on_resolution_selected(res)
		_set_resolution_text()
	
	# VSYNC
	if not vsync == null:
		if vsync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			v_sync_check_box.set_pressed_no_signal(true)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			v_sync_check_box.set_pressed_no_signal(false)
	
	# AA
	if not aa == null:
		_on_antialiasing_selected(aa)
		antialiasing_button.set_text(ANTIALIASING_ARRAY[aa])
	
	if not fps == null:
		Engine.max_fps = fps
		cur_fps_label.text = str(fps)
		fps_slider.set_value_no_signal(fps)

func _on_save_graphics_settings_button_pressed():
	_save_graphics_preferences(temp_wp_index, temp_res_index, temp_vsync_bool, temp_aa_index, temp_fps_index)

func _on_clear_graphics_settings_button_pressed():
	var config : = ConfigFile.new()
	config.load(CONFIG_SAVE_PATH)
	config.clear()
	config.save(CONFIG_SAVE_PATH)

############################## SAVING END ###################################################

func _ready() -> void:
	_add_window_mode_items()
	_add_resolution_items()
	_add_antialiasing_items()
	window_mode_button.item_selected.connect(_on_window_mode_selected)
	resolution_button.item_selected.connect(_on_resolution_selected)
	antialiasing_button.item_selected.connect(_on_antialiasing_selected)
	
	_load_graphics_preferences("graphics_preferences")

############################## WINDOW MODE ###################################################

func _add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		window_mode_button.add_item(window_mode)

func _on_window_mode_selected(index : int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_set_resolution_text()
			_disable_resolution_button()
			temp_wp_index = 0
		1: # Window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_set_resolution_text()
			center_window()
			_enable_resolution_button()
			temp_wp_index = 1
		2: # Borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			_set_resolution_text()
			center_window()
			_enable_resolution_button()
			temp_wp_index = 2
		3: # Borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			_set_resolution_text()
			_disable_resolution_button()
			temp_wp_index = 3

############################## RESOLUTION ###################################################

func _add_resolution_items() -> void:
	for resolution in RESOLUTION_DICTIONARY:
		resolution_button.add_item(resolution)
	
	_set_resolution_text()

func _disable_resolution_button() -> void:
	resolution_button.disabled = true

func _enable_resolution_button() -> void:
	resolution_button.disabled = false

func _set_resolution_text() -> void:
	var resolution_txt = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resolution_button.set_text(resolution_txt)

func _on_resolution_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	temp_res_index = index
	center_window()

func center_window() -> void:
	var center_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center_screen - window_size / 2)

############################## VSYNC ###################################################

func _on_v_sync_check_box_toggled(button_pressed) -> void:
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		temp_vsync_bool = true
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		temp_vsync_bool = false

############################## ANTIALIASING ###################################################

func _add_antialiasing_items() -> void:
	for antialiasing_mode in ANTIALIASING_ARRAY:
		antialiasing_button.add_item(antialiasing_mode)

func _on_antialiasing_selected(index : int) -> void:
	match index:
		0:
			temp_aa_index = 0
			RenderingServer.viewport_set_msaa_3d(get_tree().get_root().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED)
		1: 
			temp_aa_index = 1
			RenderingServer.viewport_set_msaa_3d(get_tree().get_root().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_2X)
		2:
			temp_aa_index = 2
			RenderingServer.viewport_set_msaa_3d(get_tree().get_root().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_4X)
		3:
			temp_aa_index = 3
			RenderingServer.viewport_set_msaa_3d(get_tree().get_root().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_8X)

############################## FPS ###################################################

func _on_fps_slider_value_changed(value) -> void:
	cur_fps_label.text = str(fps_slider.value)

func _on_fps_slider_drag_ended(_value_changed) -> void:
	Engine.max_fps = fps_slider.value
	temp_fps_index = fps_slider.value

func _set_fps_slider() -> void:
	fps_slider.set_value_no_signal(Engine.get_frames_per_second())
	cur_fps_label.text = str(Engine.get_frames_per_second())
