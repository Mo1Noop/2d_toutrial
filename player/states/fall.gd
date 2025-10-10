class_name PlayerState_fall extends Player_state


func enter() -> void:
	player.velocity.y = lerp(player.velocity.y, 0.0, 0.7)
	print("enter: ", name)
	pass


func physics_process(_delta: float) -> Player_state:
	player.velocity.y += player.gravity * _delta
	if player.is_on_floor():
		if player.dirction.x == 0:
			return idle
	if player.dirction.x != 0:
		return run
	return next_state
