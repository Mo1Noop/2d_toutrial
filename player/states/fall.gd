class_name PlayerState_fall extends Player_state

@export var coyote_time : float = 0.1
@export var jump_buffer_time : float = 0.1
@export var fall_gravity_mulitplier : float = 1.165

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0


func enter() -> void:
	player.debug( Color.RED )
	player.velocity.y *= 0.4
	player.gravity_mulitplier = fall_gravity_mulitplier
	if player.previous_state == jump:
		coyote_timer = 0.0
	else:
		coyote_timer = coyote_time

func exit() -> void:
	player.gravity_mulitplier = 1.0

func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state


func process(delta: float) -> Player_state:
	coyote_timer = max(coyote_timer - delta, 0.0)
	buffer_timer = max(buffer_timer - delta, 0.0)
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.is_on_floor():
		if buffer_timer > 0.0:
			return jump
		return idle
	return next_state
