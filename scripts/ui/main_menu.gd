extends Control


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://temp/testworld.tscn")


func _on_options_pressed():
	pass # Replace with function body.


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
