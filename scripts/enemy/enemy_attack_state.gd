class_name EnemyAttackState
extends EnemyState

@onready var current_actor = $"../.."
const Snowball = preload("res://snowball.tscn")
@onready var shoot_spot = $"../../ShootSpot"

func _ready():
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	print("me attack")
	while current_actor.target_in_range():
		var _snowball = Snowball.instantiate()
		_snowball.attacking_actor = "enemy"
		shoot_spot.add_child(_snowball)
		_snowball.apply_central_force(-shoot_spot.global_transform.basis.z * 200)
		await get_tree().create_timer(1, false).timeout
	
	state_transition.emit(self, "EnemyChaseState")

func _process(_delta):
	current_actor.look_at(Vector3(current_actor.player.global_position.x, current_actor.global_position.y, current_actor.player.global_position.z), Vector3.UP)
