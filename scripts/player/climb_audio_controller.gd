extends Node3D

@onready var climb_1 = $Climb1
@onready var climb_2 = $Climb2
@onready var climb_3 = $Climb3
@onready var climb_4 = $Climb4
@onready var climb_5 = $Climb5
@onready var climb_6 = $Climb6

func _ready():
	randomize()

func play_climb_sound() -> void:
	var rng = RandomNumberGenerator.new()
	
	var random_sound = rng.randi_range(0, 5)
	
	var sound
	
	match random_sound:
		0:
			sound = climb_1
		1:
			sound = climb_2
		2:
			sound = climb_3
		3:
			sound = climb_4
		4:
			sound = climb_5
		5:
			sound = climb_6
	
	sound.play()
