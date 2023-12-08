class_name HurtboxComponent
extends Area3D

@export_category("Energy component!")
@export var energy_component : EnergyComponent
@export var current_actor : CharacterBody3D

@onready var audio_hurt = $Hurt

func _init() -> void:
	collision_layer = 0
	collision_mask = 8

func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox == null:
		return
		
	# Checks first group tag so player can't damage player and enemies can't damage enemies
	if not hitbox.attacking_actor == current_actor.get_groups()[0]:
		audio_hurt.play()
		energy_component.inflict_damage(hitbox.damage)
