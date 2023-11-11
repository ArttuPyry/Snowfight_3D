extends Node3D

@onready var player = $".."
@onready var camera = $"../Camera3D"

func _process(_delta) -> void:
	var crosshair_position = player.crosshair.get_global_transform().get_origin() + Vector2(32, 32)
	
	var ray_origin = camera.project_ray_origin(crosshair_position)
	var ray_end = ray_origin + camera.project_ray_normal(crosshair_position) * 2.5
	
	self.look_at(ray_end)
