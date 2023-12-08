class_name BossIdleState
extends EnemyState

@onready var animation_player = $"../../AnimationPlayer"
var attack_index = 0
@onready var enemy_boss = $"../.."

func _ready():
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	animation_player.play("idle")
func _exit_state() -> void:
	set_process(false)

func _process(_delta):
	await get_tree().create_timer(0.5, false).timeout
	if attack_index == 0 and enemy_boss.enabled:
		attack_index = 1
		state_transition.emit(self, "BossSpinAttackState")
	elif attack_index == 1 and enemy_boss.enabled:
		attack_index = 0
		state_transition.emit(self, "BossCrossAttackState")
