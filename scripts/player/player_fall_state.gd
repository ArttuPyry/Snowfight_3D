class_name PlayerFallState
extends PlayerState

# Variables
const SPEED = 2.0
@onready var player = $"../.."
@onready var camera = $"../../Camera3D"
@onready var fall_timer = $FallTimer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var energy_component = $"../../EnergyComponent"

@onready var break_audio = $"../../BreakAudio"

var fall_damage = 0

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)
	# Reset fall famage and start timer
	break_audio.volume_db = -70
	fall_damage = 0
	fall_timer.start()

func _exit_state() -> void:
	# Stop fall damage timer
	fall_timer.stop()
	
	# Proc the fall damage
	if fall_damage > 0:
		energy_component.inflict_damage(fall_damage)
	
	break_audio.play()
	set_process(false)
	set_physics_process(false)

# let's player move on air
func _physics_process(delta) -> void:
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	else:
		state_transition.emit(self, "PlayerIdleState")
	
	# player moves with reduced speed compared to ground ms
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	player.move_and_slide()

func _process(delta):
	player.aim_and_rotate(delta)

# Every time timer timeouts add 1 dmage to fall damage and reset the timer
func _on_fall_timer_timeout():
	break_audio.volume_db += 20
	fall_damage += 1
	fall_timer.start()
