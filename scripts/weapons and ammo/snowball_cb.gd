extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var damage = 1
var attacking_actor : String
@onready var snowball_mesh = $snowball

@export var snow_splash = preload("res://environment/snow_splash_sprite.tscn")

func _ready():
	await get_tree().create_timer(30, false).timeout
	queue_free()

func _physics_process(delta):
	velocity.y -= gravity * delta
	var coll = move_and_collide(velocity * delta)
	if coll:
		snowball_mesh.visible = false
		await get_tree().create_timer(0.5, false).timeout
		queue_free()

func setup(move_speed):
	velocity = -global_transform.basis.z * move_speed

# Makes mesh spin, looks much nicer when ball is thrown
func _process(_delta):
	snowball_mesh.rotate_x(-0.5)

func _on_area_3d_body_entered(body):
	var ins_snow_splash = snow_splash.instantiate()
	body.add_child(ins_snow_splash)
	ins_snow_splash.global_transform.origin = self.global_transform.origin
