extends Node3D

@onready var camera = $"../../.."
@onready var player = $"../../../.."

var x_aim
var y_aim

func _process(_delta) -> void:
	# Makes hand / shoot spot always aim at crosshair
	var add_screen_size = get_viewport().get_visible_rect().size.x / 2 * 0.05
	var crosshair_position = player.crosshair.get_global_transform().get_origin() + Vector2(x_aim + add_screen_size , y_aim) # 75 = 46 0, 110 = 32 16, 50 = 72 -32
	
	var ray_origin = camera.project_ray_origin(crosshair_position)
	var ray_end = ray_origin + camera.project_ray_normal(crosshair_position) * 2.0
	
	self.look_at(ray_end)
