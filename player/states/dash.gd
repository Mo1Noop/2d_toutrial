class_name playerState_dash extends Player_state

var dash_dir : int = 0

func enter() -> void:
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(0.3).timeout
	player.change_state(fall)


func physics_process(_delta: float) -> Player_state:
	if player.hero.flip_h == false:
		dash_dir = 1
	else:
		dash_dir = -1
	player.velocity = Vector2(dash_dir * 500, 0)
	return null
