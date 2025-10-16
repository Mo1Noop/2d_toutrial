class_name PlayerState_jump extends Player_state


func enter() -> void:
	player.debug(Color.GREEN)
	player.velocity.y = player.jump_velocity
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_released("jump"):
		return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.velocity.y >= 0:
		return fall
	elif player.is_on_floor():
		return idle
	return next_state
