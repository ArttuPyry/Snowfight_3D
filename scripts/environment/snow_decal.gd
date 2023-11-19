extends Decal

func _ready():
	set_process(false)
	await get_tree().create_timer(3, false).timeout
	set_process(true)

func _process(_delta):
	if self.modulate.a > 0:
		self.modulate.a -= 0.01
	else:
		queue_free()
