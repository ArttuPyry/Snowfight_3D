class_name Snowball
extends RigidBody3D

@export var damage = 1
var attacking_actor : String
@onready var snowball_mesh = $snowball

func _ready() -> void:
	top_level = true
	contact_monitor = true
	max_contacts_reported = 1
	
	# If snowball doesn't hit anything or goes out og bounds destory in 30 sec to prevent unnecessary objects
	await get_tree().create_timer(30, false).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group(attacking_actor):
		pass
	else:
		queue_free()

# Makes mesh spin, looks much nicer when ball is thrown
func _process(_delta):
	snowball_mesh.rotate_x(-0.5)
