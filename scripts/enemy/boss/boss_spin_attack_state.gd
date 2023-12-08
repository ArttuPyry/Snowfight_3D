class_name BossSpinAttackState
extends EnemyState

@onready var animation_player = $"../../AnimationPlayer"

@export var fire_spots : Array[Node3D]

const snowball_no_grav = preload("res://weapons and ammo/snowball_cb_no_gravity.tscn")
@onready var spin_attack_timer = $SpinAttackTimer

@onready var enemy_boss = $"../.."

var attack_amount

@onready var throw = $"../../Throw"

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	attack_amount = 0
	set_process(true)
	animation_player.play("throw_attack")
	spin_attack_timer.start()

func _exit_state() -> void:
	set_process(false)

func _attack() -> void:
	for i in fire_spots.size():
		var _snowball = snowball_no_grav.instantiate()
		_snowball.attacking_actor = "boss"
		get_tree().get_root().add_child(_snowball)
		_snowball.global_transform = fire_spots[i].global_transform
		_snowball.setup(10.0)

func _on_spin_attack_timer_timeout():
	attack_amount += 1
	if attack_amount >= 10:
		state_transition.emit(self, "BossStunnedState")
	else:
		throw.play()
		spin_attack_timer.start()
		_attack()

func _process(delta):
	animation_player.play("throw_attack")
	enemy_boss.rotate_y(0.7 * delta)
