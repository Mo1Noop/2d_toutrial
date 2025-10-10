class_name PlayerState_Run extends Player_state


func enter() -> void:
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x == 0:
		return idle
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.x = player.dirction.x * player.move_speed
	return next_state
