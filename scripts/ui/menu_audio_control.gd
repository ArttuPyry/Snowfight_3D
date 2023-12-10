extends Control

@onready var hover = $"../Hover"
@onready var press = $"../Press"


func _on_mouse_entered():
	hover.play()

func _on_tab_container_tab_hovered(_tab):
	hover.play()

func play_hover_sound():
	hover.play()

func play_click_sound():
	press.play()

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
