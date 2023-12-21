extends CharacterBody3D

@export var damage = 3
var attacking_actor : String

func _ready():
	await get_tree().create_timer(15, false).timeout
	queue_free()

func _physics_process(delta):
	var coll = move_and_collide(velocity * delta)
	if coll:
		print("Collider")
		await get_tree().create_timer(0.1, false).timeout
		queue_free()

func setup(move_speed):
	velocity = -global_transform.basis.z * move_speed

