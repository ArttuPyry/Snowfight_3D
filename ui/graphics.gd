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
	"3840x2160":Vector2i(3840, 2160),
	"2560x1440":Vector2i(2560, 1440),
	"1920x1080":Vector2i(1920, 1080),
	"1366x768":Vector2i(1466, 768),
	"1536x864":Vector2i(1536, 864),
	"1280x720":Vector2i(1280, 720),
	"1440x900":Vector2i(1440, 900),
	"1600x900":Vector2i(1600, 900),
	"1024x600":Vector2i(1024, 600),
	"800x600":Vector2i(800,600)
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
	for resolution in RESOLUTION_DICTIONARY:
		resolution_button.add_item(resolution)

func _on_resolution_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
	# Bad fix for resetting
#	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#	else:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
