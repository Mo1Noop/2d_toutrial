## LOL
class_name playerState_dash extends Player_state

func enter() -> void:
	var  target_pos : float = player.position.x + player.dirction.x * 110
	var tween : Tween = create_tween()
	tween.tween_property(player, "position:x", target_pos, 0.15)

func process(_delta: float) -> Player_state:
	if player.is_on_floor():
		return idle
	else:
		return fall
