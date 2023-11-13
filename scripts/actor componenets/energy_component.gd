class_name EnergyComponent
extends Node3D

var current_energy : int
@export var actor : CharacterBody3D

func _ready():
	current_energy = actor.max_energy

func inflict_damage(damage):
	current_energy -= damage
	
	if current_energy <= 0:
		actor.dead()
