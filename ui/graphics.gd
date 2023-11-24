extends TabBar

@onready var window_mode_button = $WindowMode/WindowModeButton
@onready var resolution_button = $Resolution/ResolutionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Fullscreen",
	"Window mode",
	"Borderless window",
	"Borderless fullscreen"
]

const RESOLUTION_DICTIONARY : Dictionary = {
	"3840x2160 (16:9)":Vector2(3840, 2160),
	"2560x1440  (16:9)":Vector2(2560, 1440),
	"2048x1152 (16:9)":Vector2(2048, 1152),
	"1920x1080 (16:9)":Vector2(1920, 1080),
	"1280x720 (16:9)":Vector2(1280, 720),
	"6404x360 (16:9)":Vector2(640, 360),
	"4096x3072 (4:3)":Vector2(4096, 3072),
	"3200x2400 (4:3)":Vector2(3200, 2400),
	"2048x1536 (4:3)":Vector2(2048, 1536),
	"1440x1080 (4:3)":Vector2(1440, 1080),
	"1024x768 (4:3)":Vector2(1024, 768),
	"800x600 (4:3)":Vector2(800,600)
}

func _ready() -> void:
	_add_window_mode_items()
	_add_resolution_items()
	window_mode_button.item_selected.connect(_on_window_mode_selected)
	resolution_button.item_selected.connect(_on_resolution_selected)

############################## Window mode ###################################################

func _add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		window_mode_button.add_item(window_mode)

func _on_window_mode_selected(index : int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

############################## RESOLUTION ###################################################

func _add_resolution_items() -> void:
	var current_resolution = get_viewport().get_visible_rect().size
	var index = 0
	
	for resolution in RESOLUTION_DICTIONARY:
		resolution_button.add_item(resolution)
		if RESOLUTION_DICTIONARY[resolution] == current_resolution:
			resolution_button.select(index)
		index += 1

func _on_resolution_selected(index : int) -> void:
	# Save window mode
#	var mode = DisplayServer.window_get_mode()
#	var flag = DisplayServer.window_get_flag(0)
#
#	# Set mode to windowed so resolution change works
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
	# Set mode back to saved mode
#	DisplayServer.window_set_mode(mode)
#	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, flag)
	print(DisplayServer.window_get_size())
	
