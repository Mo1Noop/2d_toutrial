## i do not know why the gravity is incresing while in this state
class_name playerState_hover extends Player_state

var hover_velocity : float = 60.0

func enter() -> void:
	player.velocity = Vector2.ZERO


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_released("jump"):
		if !player.is_on_floor():
			return fall
		else:
			return idle
	return next_state

func process(_delta: float) -> Player_state:
	if player.is_on_floor():
		return idle
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move( randf_range(150, 180) )
	player.velocity.y = hover_velocity
	return next_state
