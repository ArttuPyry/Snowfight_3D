extends AudioStreamPlayer3D

@onready var step00 = preload("res://sounds/characters/step_00_iliasflou.mp3")
@onready var step01 = preload("res://sounds/characters/step_01_iliasflou.mp3")
@onready var step02 = preload("res://sounds/characters/step_02_iliasflou.mp3")
@onready var step03 = preload("res://sounds/characters/step_03_iliasflou.mp3")
@onready var step04 = preload("res://sounds/characters/step_04_iliasflou.mp3")
@onready var step05 = preload("res://sounds/characters/step_05_iliasflou.mp3")

func _ready():
	randomize()

func _on_finished():
	var rng = RandomNumberGenerator.new()
	var random_sound = rng.randi_range(0, 5)
	match random_sound:
		0:
			self.stream = step00
		1:
			self.stream = step01
		2:
			self.stream = step02
		3:
			self.stream = step03
		4:
			self.stream = step04
		5:
			self.stream = step05

func play_step_sound() -> void:
	if not self.playing:
		self.play()

