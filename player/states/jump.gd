class_name PlayerState_jump extends Player_state


func init() -> void:
	print("init: ", name)
	pass


func enter() -> void:
	print("enter: ", name)
	pass


func exit() -> void:
	print("exit: ", name)
	pass


func handle_input(_event : InputEvent) -> Player_state:
	return next_state


func process(_delta: float) -> Player_state:
	return next_state


func physics_process(_delta: float) -> Player_state:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = -300
	return next_state
