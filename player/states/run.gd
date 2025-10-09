class_name PlayerState_Run extends Player_state


func init() -> void:
	print("init: ", name)
	pass


func enter() -> void:
	if player.velocity != Vector2.ZERO:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 1)
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_released():
		return player.idle
	if _event.is_pressed() and _event.is_action_pressed("jump"):
		return player.jump
	
	return next_state


func process(_delta: float) -> Player_state:
	return next_state


func physics_process(_delta: float) -> Player_state:
	if Input.is_action_pressed("left"):
		player.velocity.x = -player.speed
	
	if Input.is_action_pressed("right"):
		player.velocity.x = player.speed
	
	return next_state
