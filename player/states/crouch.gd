class_name PlayerState_crouch extends Player_state

@export var slow_dwon_rate : float = 10.0

func enter() -> void:
	player.player_anim.play("crouch")
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false

func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("jump") and player._get_collisions():
		player.position.y += 2
		return fall
	elif _event.is_action_pressed("jump") and not player._get_collisions():
		return jump
	return next_state

func process(_delta: float) -> Player_state:
	if player.dirction.y == 0.0:
		if player.is_on_floor():
			player.player_anim.play_backwards("crouch")
			return idle
		else:
			return fall
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.x -= player.velocity.x * slow_dwon_rate * _delta
	return next_state
