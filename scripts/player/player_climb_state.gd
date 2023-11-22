class_name PlayerClimbState
extends PlayerState

const SPEED = 3
@onready var player = $"../.."
@onready var ray_cast = $"../../LadderRayCast"
@onready var animation_player = $"../../AnimationPlayer"
@onready var hands = $"../../Camera3D/Hands"


func _ready() -> void:
	hands.visible = false
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	hands.rotation.y = 0
	hands.visible = true
	set_process(true)
	set_physics_process(true)

func _exit_state() -> void:
	hands.rotation.y = 0
	hands.visible = false
	animation_player.stop(true)
	set_process(false)
	set_physics_process(false)

func _physics_process(_delta):
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("ladder_mesh"):
			if Input.is_action_pressed("move_forward"):
				animation_player.play("climb")
				player.velocity.y = SPEED
				player.move_and_slide()
			elif Input.is_action_pressed("move_backwards"):
				animation_player.play_backwards("climb")
				player.velocity.y = -SPEED
				player.move_and_slide()
			else:
				animation_player.pause()
			
			if Input.is_action_pressed("move_backwards") and player.is_on_floor():
				state_transition.emit(self, "PlayerRunState")
			
			if Input.is_action_pressed("move_left"):
				state_transition.emit(self, "PlayerRunState")
			
			if Input.is_action_pressed("move_right"):
				state_transition.emit(self, "PlayerRunState")
		else:
			state_transition.emit(self, "PlayerRunState")
	else:
		state_transition.emit(self, "PlayerRunState")

func _process(_delta):
	player.aim_and_rotate()
