class_name PlayerState_Idle extends Player_state


func enter() -> void:
	player.player_anim.play("idle")
	player.velocity.x = 0.0
	player.jump_count = 0
	player.dash_count = 0
	player.attack_sprite.visible = false


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	if _event.is_action_pressed("action") and player.can_morph():
		return ball
	
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x != 0:
		return run
	elif player.dirction.y > 0.5:
		return crouch
	elif !player.is_on_floor():
		return fall
	return next_state
