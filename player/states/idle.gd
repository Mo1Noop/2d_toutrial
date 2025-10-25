class_name PlayerState_Idle extends Player_state


func enter() -> void:
	player.velocity = Vector2.ZERO
	player.player_anim.play("idle")
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	if _event.is_action_pressed("dash"):
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
