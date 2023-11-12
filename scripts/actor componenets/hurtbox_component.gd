class_name HurtboxComponent
extends Area3D

@export_category("Energy component!")
@export var energy_component : EnergyComponent

func _init() -> void:
	collision_layer = 0
	collision_mask = 8

func _on_area_entered(hitbox: HitboxComponent) -> void:
	print("TEST")
	if hitbox == null:
		return
	
	energy_component.inflict_damage(hitbox.damage)
