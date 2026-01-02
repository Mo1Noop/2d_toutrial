class_name PlayerState_Idle extends Player_state


func enter() -> void:
	player.player_anim.play("idle")
	player.velocity = Vector2.ZERO


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x != 0:
		return run
	elif player.dirction.y > 0.5:
		return crouch
	elif !player.is_on_floor():
		return fall
	return next_state
