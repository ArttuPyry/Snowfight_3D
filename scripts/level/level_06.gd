extends Node3D

@onready var user_interface = $UserInterface
@onready var lvl_text = $LvlText
@onready var hover = $Hover
@onready var press = $Press

func _ready():
	await get_tree().create_timer(0.1, false).timeout
	
	user_interface.visible = false
	lvl_text.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_texture_button_mouse_entered():
	hover.play()


func _on_texture_button_pressed():
	press.play()
	get_tree().paused = false
	lvl_text.visible = false
	user_interface.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
