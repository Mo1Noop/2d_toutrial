class_name PlayerState_Run extends Player_state

var coyote_timer : float = 0.0
var coyote_time : float = 0.1

func enter() -> void:
	coyote_timer = coyote_time


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if !player.is_on_floor():
		coyote_timer = max(coyote_timer - _delta, 0.0)
		if coyote_timer > 0.0 and Input.is_action_just_pressed("jump"):
			return jump
		if coyote_timer == 0.0:
			return fall
	elif player.dirction.x == 0:
		return idle
	return next_state
