class_name PlayerState_fall extends Player_state

func enter() -> void:
	player.velocity.y *= 0.3
	pass


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.is_on_floor():
		return idle
	return next_state
