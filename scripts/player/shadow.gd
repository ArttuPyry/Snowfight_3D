extends Sprite3D

@onready var shadow_ray_cast = $"../ShadowRayCast"

func _process(_delta):
	if shadow_ray_cast.is_colliding():
		var point = shadow_ray_cast.get_collision_point()
		self.global_position = point + Vector3(0, 0.01, 0)
