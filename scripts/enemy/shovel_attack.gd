extends Node3D

@export var damage = 5
@export var attacking_actor : String

var turn_speed = 1000.0

func face_point(point: Vector3, delta: float):
	var l_point = to_local(point)
	l_point.y = 0.0
	
	var turn_dir = sign(Vector3.RIGHT.dot(l_point))
	var turn_amnt = deg_to_rad(turn_speed * delta)
	var angle = Vector3.FORWARD.angle_to(l_point)
	
	if angle < turn_amnt:
		rotate_object_local(Vector3.RIGHT, -angle * turn_dir)
	else:
		rotate_object_local(Vector3.RIGHT, -turn_amnt * turn_dir)

