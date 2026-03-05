class_name PlayerState_fall extends Player_state

@export var fall_gravity_mulitplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.1
@onready var land_audio: AudioStreamPlayer2D = %land_audio

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0


func enter() -> void:
	player.player_anim.play("jump")
	player.player_anim.pause()
	player.velocity.y *= 0.4
	player.gravity_mulitplier = fall_gravity_mulitplier
	
	if player.jump_count == 0:
		player.jump_count = 1
	
	if player.previous_state in [ jump, attack, dash ]:
		coyote_timer = 0.0
	elif player.previous_state == crouch:
		coyote_timer = 0.0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time


func exit() -> void:
	player.gravity_mulitplier = 1.0


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return attack
	
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0.0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
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
		land_audio.play()
		VisualEffects.land_dust( player.global_position )
		if buffer_timer > 0.0:
			player.jump_count = 0
			return jump
		return idle
	
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.player_anim.seek(frame, true)
