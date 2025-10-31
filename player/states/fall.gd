class_name PlayerState_fall extends Player_state

@export var coyote_time : float = 0.1
@export var jump_buffer_time : float = 0.1
@export var fall_gravity_mulitplier : float = 1.165

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0


func enter() -> void:
	player.player_anim.play("jump")
	player.player_anim.pause()
	player.debug( Color.RED )
	player.velocity.y *= 0.4
	player.gravity_mulitplier = fall_gravity_mulitplier
	if player.previous_state in [jump, dash]:
		coyote_timer = 0.0
	else:
		coyote_timer = coyote_time

func exit() -> void:
	player.gravity_mulitplier = 1.0

func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("dash") and player.previous_state != dash:
		return dash
	elif _event.is_action_pressed("jump") and player.jump_counter < 3:
		if player.can_duble_jump:
			player.can_duble_jump = false
			return jump
		elif coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state


func process(delta: float) -> Player_state:
	coyote_timer = max(coyote_timer - delta, 0.0)
	buffer_timer = max(buffer_timer - delta, 0.0)
	set_jump_frame()
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.is_on_floor():
		if buffer_timer > 0.0:
			return jump
		return idle
	
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.player_anim.seek(frame, true)
