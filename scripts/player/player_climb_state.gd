class_name PlayerClimbState
extends PlayerState

const SPEED = 3
@onready var player = $"../.."
@onready var ray_cast = $"../../LadderRayCast"
@onready var animation_player = $"../../AnimationPlayer"
@onready var hands = $"../../Camera3D/Hands"
@onready var snowball = $"../../Camera3D/Hands/snowball"
@onready var right_hand = $"../../Camera3D/Hands/RightHand"

@onready var climb_audio = $"../../ClimbAudio"

func _ready() -> void:
	hands.visible = false
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void:
	# Set hands to og spot and make em visible
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = true
	right_hand.position.y = -0.313
	right_hand.position.x = 0.244
	right_hand.position.z = -0.299
	right_hand.rotation.y = -124-9
	right_hand.rotation.x = 0
	right_hand.rotation.z = 88
	snowball.visible = false
	set_process(true)
	set_physics_process(true)
	
	player.velocity.x = 0
	player.velocity.z = 0

func _exit_state() -> void:
	# Set hands to og spot and make em invisible
	hands.rotation.y = 0
	hands.rotation.x = 0
	hands.rotation.z = 0
	hands.visible = false
	animation_player.stop(true)
	set_process(false)
	set_physics_process(false)

# Cursed script here!
func _physics_process(_delta):
	# Check if raycast is colliding, its positioned at players feet
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("ladder_mesh"): # If it collides with ladder and press up and down play anim
			if Input.is_action_pressed("move_forward"):
				animation_player.play("climb")
				player.velocity.y = SPEED
				player.move_and_slide()
			elif Input.is_action_pressed("move_backwards"):
				animation_player.play_backwards("climb")
				player.velocity.y = -SPEED
				player.move_and_slide()
			else:
				# Pauses the anim
				animation_player.pause() 
			
			# Player climbs down and hit ground swap to run
			if Input.is_action_pressed("move_backwards") and player.is_on_floor():
				state_transition.emit(self, "PlayerRunState")
			
			# If player moves left or right jump off the ladder
			if Input.is_action_pressed("move_left"):
				state_transition.emit(self, "PlayerRunState")
			
			if Input.is_action_pressed("move_right"):
				state_transition.emit(self, "PlayerRunState")
		else:
			state_transition.emit(self, "PlayerRunState")
	else:
		state_transition.emit(self, "PlayerRunState")

func _process(delta):
	player.aim_and_rotate(delta)
	
	if player.no_energy:
		state_transition.emit(self, "PlayerLoseState")
