extends Control

@onready var main_buttons = $MainButtons
@onready var options = $Options



func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")

func _on_options_pressed():
	main_buttons.visible = false
	options.visible = true

func _on_exit_options_menu_pressed():
	main_buttons.visible = true
	options.visible = false

func _on_credits_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
