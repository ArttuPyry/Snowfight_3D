extends Node3D

@onready var snowball = $snowball

func _ready():
	set_process(false)
	await get_tree().create_timer(3, false).timeout
	set_process(true)

func _process(_delta):
	if snowball.transparency < 1:
		snowball.transparency += 0.007
	else:
		queue_free()
