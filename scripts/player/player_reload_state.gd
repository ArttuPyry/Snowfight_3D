class_name PlayerReloadState
extends PlayerState

func _ready() -> void:
	set_process(false)

func _enter_state() -> void:
	set_process(true)
	print("Enter RELOAD state")
	await get_tree().create_timer(2, false).timeout
	state_transition.emit(self, "PlayerIdleState")

func _exit_state() -> void:
	set_process(false)

func _process(_delta):
	print("RELOADING")

