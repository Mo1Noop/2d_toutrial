class_name PlayerState_Run extends Player_state


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if !player.is_on_floor():
		return fall
	elif player.dirction.x == 0:
		return idle
	return next_state
