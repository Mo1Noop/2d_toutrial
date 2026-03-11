class_name PlayerState_ball extends Player_state

const MORPH_AUDIO = preload("uid://cnwtnak7kachk")
const MORPH_OUT_AUDIO = preload("uid://dls8gc1jdc8yr")
@export var jump_velocity : float = -400

var on_floor : bool = true
@onready var ball_ray_up: RayCast2D = %ball_rayUP
@onready var ball_ray_down: RayCast2D = %ball_rayDOWN
@onready var jump_audio: AudioStreamPlayer2D = %jump_audio
@onready var land_audio: AudioStreamPlayer2D = %land_audio



func enter() -> void:
	player.player_anim.play("ball")
	Audio.play_apatial_sound( MORPH_AUDIO, player.global_position )
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 11.0
	shape.height = 22.0
	
	player.collision_stand.position.y = -11.0
	player.da_stand.position.y = -11.0
	player.velocity.y -= 100.0


func exit() -> void:
	player.velocity.y -= 100.0
	player.player_anim.speed_scale = 1
	Audio.play_apatial_sound( MORPH_OUT_AUDIO, player.global_position )
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 8.0
	shape.height = 46.0
	
	player.collision_stand.position.y = -23.0
	player.da_stand.position.y = -23.0


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("action"):
		if can_stand():
			if player.is_on_floor():
				return idle
			return fall
	if _event.is_action_pressed("jump") and player.is_on_floor():
		if Input.is_action_pressed("down"):
			player.one_way_chape_cast.force_shapecast_update()
			if player.one_way_chape_cast.is_colliding():
				player.position.y += 4
				return null
		player.velocity.y = jump_velocity
		jump_audio.play()
		VisualEffects.jump_dust( player.global_position )
	return next_state


func process(_delta: float) -> Player_state:
	if player.dirction.x == 0.0:
		player.player_anim.speed_scale = 0.0
	else:
		player.player_anim.speed_scale = 1.0
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.move()
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust( player.global_position )
			land_audio.play()
	return null


func can_stand() -> bool:
	ball_ray_up.force_raycast_update()
	ball_ray_down.force_raycast_update()
	if ball_ray_down.is_colliding() and ball_ray_up.is_colliding():
		return false
	return true
