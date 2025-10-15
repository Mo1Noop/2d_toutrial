class_name PlayerState_jump extends Player_state

var jump_timer : float = 0.0


func enter() -> void:
	player.velocity.y = player.jump_velocity
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_released("jump"):
		return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	return next_state
