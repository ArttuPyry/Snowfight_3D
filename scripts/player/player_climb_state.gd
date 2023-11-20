class_name PlayerClimbState
extends PlayerState

const SPEED = 3
@onready var player = $"../.."
@onready var ray_cast = $"../../RayCast3D"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	set_process(false)
	set_physics_process(false)

func _physics_process(_delta):
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("ladder_mesh"):
			if Input.is_action_pressed("move_forward"):
				player.velocity.y = SPEED
				player.move_and_slide()
			
			if Input.is_action_pressed("move_backwards"):
				player.velocity.y = -SPEED
				player.move_and_slide()
			
			if Input.is_action_pressed("move_left"):
				state_transition.emit(self, "PlayerRunState")
			
			if Input.is_action_pressed("move_right"):
				state_transition.emit(self, "PlayerRunState")
		else:
			state_transition.emit(self, "PlayerRunState")

func _process(_delta):
	player.aim_and_rotate()
