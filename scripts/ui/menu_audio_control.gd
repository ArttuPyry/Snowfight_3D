extends Control

@onready var audio_buttons = $"../Buttons"

@onready var click = preload("res://Sounds/ui/menu_click_click_shasha213131.mp3")
@onready var hover = preload("res://Sounds/ui/menu_hover_click_shasha213131.mp3")

func _on_mouse_entered():
	audio_buttons.stream = hover
	audio_buttons.play()

func _on_tab_container_tab_hovered(_tab):
	audio_buttons.stream = hover
	audio_buttons.play()

func play_hover_sound():
	audio_buttons.stream = hover
	audio_buttons.play()

func play_click_sound():
	audio_buttons.stream = click
	audio_buttons.play()

func _on_tab_container_tab_clicked(_tab):
	play_click_sound()

func _on_tab_container_tab_selected(_tab):
	play_click_sound()

func _on_window_mode_button_toggled(_button_pressed):
	play_click_sound()

func _on_resolution_button_toggled(_button_pressed):
	play_click_sound()

func _on_antialiasing_button_toggled(_button_pressed):
	play_click_sound()


