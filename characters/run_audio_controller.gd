extends Node3D

@onready var steps_1 = $Steps1
@onready var steps_2 = $Steps2
@onready var steps_3 = $Steps3
@onready var steps_4 = $Steps4
@onready var steps_5 = $Steps5
@onready var steps_6 = $Steps6

func _ready():
	randomize()

func play_step_sound() -> void:
	var rng = RandomNumberGenerator.new()
	
	var random_sound = rng.randi_range(0, 5)
	
	var sound
	
	match random_sound:
		0:
			sound = steps_1
		1:
			sound = steps_2
		2:
			sound = steps_3
		3:
			sound = steps_3
		4:
			sound = steps_4
		5:
			sound = steps_5
	
	if not steps_1.playing \
		and not steps_2.playing \
		and not steps_3.playing \
		and not steps_4.playing \
		and not steps_5.playing:
		sound.play()
