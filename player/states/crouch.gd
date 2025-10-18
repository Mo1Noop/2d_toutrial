class_name PlayerState_crouch extends Player_state

func enter() -> void:
	player.velocity.x = 0


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump"):
		player.position.y += 1
		return fall
	if _event.is_action_released("down"):
		if player.is_on_floor():
			return idle
		else:
			return fall
	return next_state

func physics_process(_delta: float) -> Player_state:
	player.move(player.move_speed/2)
	return next_state
