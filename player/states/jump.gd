class_name PlayerState_jump extends Player_state

@export var jump_velocity : float = -425
@onready var jump_audio: AudioStreamPlayer2D = %jump_audio


func enter() -> void:
	player.player_anim.play("jump")
	player.player_anim.pause()
	if player.is_on_floor():
		VisualEffects.jump_dust( player.global_position )
	else:
		VisualEffects.land_dust( player.global_position )
	do_jump()
	


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("attack"):
		return attack
	
	if _event.is_action_released("jump"):
		return fall
	return next_state

func process(_delta: float) -> Player_state:
	set_jump_frame()
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if player.velocity.y >= 0:
		return fall
	elif player.is_on_floor():
		return idle
	return next_state


func do_jump() -> void:
	if player.jump_count > 0:
		if not player.double_jump:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = jump_velocity
	jump_audio.play()


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, jump_velocity, 0.0, 0.0, 0.5)
	player.player_anim.seek(frame, true)
	pass
