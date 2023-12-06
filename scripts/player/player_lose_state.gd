class_name PlayerLoseState
extends PlayerState

@onready var player = $"../.."
@onready var animation_player = $"../../AnimationPlayer"
@onready var hands = $"../../Camera3D/Hands"
@onready var player_hand_throw = $"../../Camera3D/PlayerHandThrow"
@onready var ray_cast = $"../../LoseRayCast"

@onready var audio_lose = $"../../Lose"

func _enter_state() -> void:
	player.set_process_unhandled_input(false)
	hands.visible = false
	player_hand_throw.visible = false
	
	if ray_cast.is_colliding():
		var point = ray_cast.get_collision_point()
		var TW = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		var distance_to_point = player.global_transform.origin.distance_to(point + Vector3(0, 1, 0))
		TW.tween_property(player, "transform", player.transform.translated_local(Vector3.DOWN * distance_to_point), distance_to_point / 4)
		await  TW.finished
		animation_player.play("lose")
		audio_lose.play()
		await animation_player.animation_finished
		player.you_lost()
