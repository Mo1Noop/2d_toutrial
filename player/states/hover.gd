class_name playerState_hover extends Player_state

@export var hover_velocity : float = 60.0
@export_range(80, 100) var rand_hover_speed : float = randf_range(80, 100)


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
	player.move( rand_hover_speed )
	player.velocity.y = hover_velocity
	return next_state
