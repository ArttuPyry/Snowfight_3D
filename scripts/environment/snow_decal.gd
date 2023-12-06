extends Node3D

@onready var sprite = $Sprite3D
@onready var audio_player = $AudioStreamPlayer3D

func _ready():
	set_process(false)
	audio_player.play()
	await get_tree().create_timer(0.5, false).timeout
	set_process(true)

func _process(_delta):
	if sprite.modulate.a > 0:
		sprite.modulate.a -= 0.3
	else:
		queue_free()
