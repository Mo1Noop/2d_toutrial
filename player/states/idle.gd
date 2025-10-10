class_name PlayerState_Idle extends Player_state


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
	if player.dirction.x != 0:
		return run
	if !player.is_on_floor():
		return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.x = 0
	return next_state
