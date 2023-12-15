extends TabBar

@onready var keybind_resource : KeybindResource = preload("res://scripts/ui/keybinds_default.tres")

func _ready() -> void:
	pass
	# keybind thing here

func set_keybind(action : String, event) -> void:
	match action:
		keybind_resource.LOOK_UP:
			keybind_resource.look_up_key = event
		keybind_resource.LOOK_DOWN:
			keybind_resource.look_down_key = event
		keybind_resource.LOOK_LEFT:
			keybind_resource.look_left_key = event
		keybind_resource.LOOK_RIGHT:
			keybind_resource.look_right_key = event
		keybind_resource.MOVE_FORWARD:
			keybind_resource.move_forward_key = event
		keybind_resource.MOVE_BACKARD:
			keybind_resource.move_backward_key = event
		keybind_resource.MOVE_LEFT:
			keybind_resource.move_left_key = event
		keybind_resource.MOVE_RIGHT:
			keybind_resource.move_right_key = event
		keybind_resource.ATTACK:
			keybind_resource.attack_key = event
		keybind_resource.RELOAD:
			keybind_resource.reload_key = event
		keybind_resource.INTERACT:
			keybind_resource.interact_key = event
		keybind_resource.PAUSE:
			keybind_resource.pause_key = event

func create_keybinds_dictionary() -> Dictionary:
	var keybinds_container_dict = {
		keybind_resource.LOOK_UP : keybind_resource.look_up_key,
		keybind_resource.LOOK_DOWN : keybind_resource.look_down_key,
		keybind_resource.LOOK_LEFT : keybind_resource.look_left_key,
		keybind_resource.LOOK_RIGHT : keybind_resource.look_right_key,
		
		keybind_resource.move_forwards : keybind_resource.move_forwards_key,
		keybind_resource.move_backward : keybind_resource.move_backward_key,
		keybind_resource.MOVE_LEFT : keybind_resource.move_left_key,
		keybind_resource.MOVE_RIGHT : keybind_resource.move_right_key,
		
		keybind_resource.ATTACK : keybind_resource.attack_key,
		keybind_resource.RELOAD : keybind_resource.attack_key,
		keybind_resource.INTERACT : keybind_resource.interact_key,
		
		keybind_resource.PAUSE : keybind_resource.pause_key
	}
	
	return keybinds_container_dict

func on_keybinds_loaded(data : Dictionary) -> void:
	var loaded_look_up = InputEventKey.new()
	var loaded_look_down = InputEventKey.new()
	var loaded_look_left = InputEventKey.new()
	var loaded_look_right = InputEventKey.new()
	
	var loaded_move_forwards = InputEventKey.new()
	var loaded_move_backward = InputEventKey.new()
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	
	var loaded_attack = InputEventKey.new()
	var loaded_reload = InputEventKey.new()
	var loaded_interact = InputEventKey.new()
	
	var loaded_pause = InputEventKey.new()
	
	loaded_look_up.set_physical_keycode(int(data.look_up))
	loaded_look_down.set_physical_keycode(int(data.look_down))
	loaded_look_left.set_physical_keycode(int(data.look_left))
	loaded_look_right.set_physical_keycode(int(data.look_right))
	
	loaded_move_forwards.set_physical_keycode(int(data.move_forwards))
	loaded_move_backward.set_physical_keycode(int(data.move_backward))
	loaded_move_left.set_physical_keycode(int(data.move_left))
	loaded_move_right.set_physical_keycode(int(data.moveright))
	
	loaded_attack.set_physical_keycode(int(data.attack))
	loaded_reload.set_physical_keycode(int(data.reload))
	loaded_interact.set_physical_keycode(int(data.interact))
	
	loaded_pause.set_physical_keycode(int(data.pause))
	
	keybind_resource.look_up_key = loaded_look_up
	keybind_resource.look_down_key = loaded_look_down
	keybind_resource.look_left_key = loaded_look_left
	keybind_resource.look_right_key = loaded_look_right
	
	keybind_resource.move_forwards_key = loaded_move_forwards
	keybind_resource.move_backward_key = loaded_move_backward
	keybind_resource.move_left_key = loaded_move_left
	keybind_resource.move_right_key = loaded_move_right
	
	keybind_resource.attack_key = loaded_attack
	keybind_resource.reload_key = loaded_reload
	keybind_resource.interact_key = loaded_interact
	
	keybind_resource.pause_key = loaded_pause
