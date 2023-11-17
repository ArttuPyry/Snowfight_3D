class_name EnergyComponent
extends Node3D

var current_energy : int
@export var actor : CharacterBody3D

func _ready():
	current_energy = actor.max_energy

func inflict_damage(damage):
	if actor.is_in_group("enemy") and not actor.seen_player:
		damage = damage * 2
	
	current_energy -= damage
	
	if current_energy <= 0:
		actor.no_health()
