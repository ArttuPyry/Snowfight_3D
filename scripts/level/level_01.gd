extends Node3D

@onready var hover = $Hover
@onready var press = $Press
@onready var tutorial_and_text = $TutorialAndText
@onready var user_interface = $UserInterface
@onready var label = $TutorialAndText/MarginContainer/PanelContainer/Label

@onready var player = $Player


var tutorial_check = false

func _ready():
	SaveManager.clear_timefile()
	
	await get_tree().create_timer(0.1, false).timeout
	
	tutorial_and_text.visible = true
	user_interface.visible = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func _on_texture_button_mouse_entered():
	hover.play()

func _on_texture_button_pressed():
	if LevelManager.tutorials_disabled or tutorial_check == true:
		press.play()
		get_tree().paused = false
		tutorial_and_text.visible = false
		user_interface.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		press.play()
		tutorial_check = true
		
		label.text = "You can move by pressing
		WASD keys!
		
		Use arrow or JKLI keys
		to rotate the camera.
		If you prefer mouse enable
		Mouse controlled camera from settings
		
		Throw snowball: MouseLeft, E or C
		
		Reload:  MouseMiddle, R or X
		
		Destroy snowmen and climb ladders:
		MouseRight, F or X
		
		Pause: ESC or TAB
		"
	
