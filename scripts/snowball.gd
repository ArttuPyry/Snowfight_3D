extends RigidBody3D

const DAMAGE = 1
const SPEED = 2

func _ready() -> void:
	top_level = true
	contact_monitor = true
	max_contacts_reported = 1
	
	
	await get_tree().create_timer(30, false).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("ground"):
		queue_free()
