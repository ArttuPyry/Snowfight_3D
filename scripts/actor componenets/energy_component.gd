class_name EnergyComponent
extends Node3D

var current_energy : int
@export var actor : CharacterBody3D

func _ready():
	current_energy = actor.max_energy

func inflict_damage(damage):
	# Double damage when enemy haven't seen player
	if actor.is_in_group("enemy") and not actor.seen_player:
		damage = damage * 2
		actor.seen_player = true
	
	current_energy -= damage
	
	# This is to update player health bar
	if actor.is_in_group("player"):
		actor.update_health_bar(damage)
	
	if current_energy <= 0:
		actor.no_health()
