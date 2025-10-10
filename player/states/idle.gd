class_name PlayerState_Idle extends Player_state



func init() -> void:
	print("init: ", name)
	pass


func enter() -> void:
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x != 0:
		return run
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.x = 0
	return next_state
