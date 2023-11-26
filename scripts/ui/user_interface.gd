extends Control

@onready var crosshair = $CenterContainer/Crosshair

@onready var max_ammo = $Ammo/Max
@onready var current_ammo = $Ammo/Current
@onready var energy_bar = $Energy/EnergyBar

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.crosshair = crosshair

func setup_ui(energy, ammo) -> void:
	energy_bar.value = energy
	energy_bar.max_value = energy
	max_ammo.text = str(ammo)
	current_ammo.text = str(ammo)

func update_energy(damage) -> void:
	energy_bar.value -= damage

func update_ammo() -> void:
	current_ammo.text = str(player.current_snowball_count)
