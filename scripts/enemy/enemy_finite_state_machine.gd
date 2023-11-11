class_name EnemyFiniteStateMachine
extends Node

# Initial state
@export var initial_state : EnemyState

var current_state : EnemyState
var states : Dictionary = {}

func _ready() -> void:
	# Checks children for EnemyStates and adds them to states Dictionary
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.state_transition.connect(_on_child_transition)
	
	# At start sets state to initial state
	if initial_state:
		initial_state._enter_state()
		current_state = initial_state

func _process(delta) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta) -> void:
	if current_state:
		current_state.Physics_Update(delta)

# Func to trnasition the state
func _on_child_transition(state, new_state_name) -> void:
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Exists last state and applies new state
	if current_state:
		current_state._exit_state()
		new_state._enter_state()
		current_state = new_state

func force_dead_state() -> void:
	var dead_state = states.get("EnemyDeadState")
	current_state._exit_state()
	dead_state._enter_state()
