class_name PlayerState_jump extends Player_state

@export var jump_velocity : float = -425


func enter() -> void:
	if player.jump_counter >= 2:
		player.change_state(fall)
		return
	elif player.can_duble_jump == false:
		player.velocity.y = (jump_velocity * 0.88)
	else:
		player.velocity.y = jump_velocity
	player.jump_counter += 1
	player.player_anim.play("jump")
	player.player_anim.pause()
	#player.debug(Color.GREEN)


func handle_input(_event : InputEvent) -> Player_state:

	if _event.is_action_pressed("dash"):
		return dash
	elif _event.is_action_released("jump"):
		return fall
	return next_state

func process(_delta: float) -> Player_state:
	set_jump_frame()
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.velocity.y >= 0:
		return fall
	elif player.is_on_floor():
		return idle
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, jump_velocity, 0.0, 0.0, 0.5)
	player.player_anim.seek(frame, true)
	pass
