class_name PlayerState_Idle extends Player_state


func enter() -> void:
	player.player_anim.play("idle")
	player.velocity = Vector2.ZERO
	player.can_duble_jump = true
	player.jump_counter = 0
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	elif _event.is_action_pressed("dash"):
		return dash
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x != 0:
		return run
	if player.dirction.y > 0.5:
		return crouch
	if !player.is_on_floor():
		return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	return next_state
