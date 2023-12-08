extends AudioStreamPlayer3D

@onready var climb00 = preload("res://sounds/characters/ladder_climb_00_ienba.mp3")
@onready var climb01 = preload("res://sounds/characters/ladder_climb_01_ienba.mp3")
@onready var climb02 = preload("res://sounds/characters/ladder_climb_02_ienba.mp3")
@onready var climb03 = preload("res://sounds/characters/ladder_climb_03_ienba.mp3")
@onready var climb04 = preload("res://sounds/characters/ladder_climb_04_ienba.mp3")
@onready var climb05 = preload("res://sounds/characters/ladder_climb_05_ienba.mp3")

func _ready():
	randomize()

func _on_finished():
	var rng = RandomNumberGenerator.new()
	var random_sound = rng.randi_range(0, 5)
	match random_sound:
		0:
			self.stream = climb00
		1:
			self.stream = climb01
		2:
			self.stream = climb02
		3:
			self.stream = climb03
		4:
			self.stream = climb04
		5:
			self.stream = climb05

func play_climb_sound() -> void:
	if not self.playing:
		self.play()
