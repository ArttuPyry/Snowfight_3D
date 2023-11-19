extends Area3D

var decal = preload("res://decal.tscn")
@onready var snowball = $".."

func _on_body_entered(body):
	print(body)
	var ins_decal = decal.instantiate()
	body.add_child(ins_decal)
	ins_decal.global_transform.origin = snowball.global_transform.origin
