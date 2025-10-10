class_name PlayerState_jump extends Player_state

var jump_timer : float = 0.0


func enter() -> void:
	jump_timer = 0.0
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_released("jump"):
		jump_timer = 0.0
		return fall
	return next_state


func process(_delta: float) -> Player_state:
	jump_timer += _delta
	if jump_timer > 0.21:
		return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.y = lerp(player.velocity.y, player.jump_velocity, 1)
	#player.velocity.y = player.jump_velocity
	return next_state
