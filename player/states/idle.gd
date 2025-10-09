class_name PlayerState_Idle extends Player_state



func init() -> void:
	print("init: ", name)
	pass


func enter() -> void:
	if player.velocity.x != 0:
		player.velocity.x = lerp(player.velocity.x, 0.0, 1)
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("left") or _event.is_action_pressed("right"):
		return player.run
	elif _event.is_action_pressed("jump"):
		return player.jump
	return next_state


func process(_delta: float) -> Player_state:
	return next_state


func physics_process(_delta: float) -> Player_state:
	return next_state
