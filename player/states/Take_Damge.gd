class_name PlayerState_Take_Damge extends Player_state

@onready var damege_area: Damege_area = %Damege_area
@onready var damge_audio: AudioStreamPlayer2D = %damge_audio

@export var move_speed : float = 70.0 # knokback
@export var damge_cooldown_duration : float = 0.5

var time : float = 0.0
var dir : float = 1.0 


func init() -> void:
	damege_area.damge_taken.connect( on_damge_taken )


func enter() -> void:
	player.player_anim.play("take_damge")
	time = player.player_anim.current_animation_length
	damege_area.make_invurable( damge_cooldown_duration )
	damge_audio.play()
	blink()
	VisualEffects.camera_chake(1.5)


func on_damge_taken( attack_area : Attack_Area) -> void:
	if player.current_state == death:
		return
	player.change_state( self )
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0


func process(_delta: float) -> Player_state:
	time -= _delta
	if time <= 0.0:
		if player.hp <= 0:
			return death
		return idle
	return null


func physics_process(_delta: float) -> Player_state:
	player.velocity.x = move_speed * dir
	return null


func blink() -> void:
	var tween : Tween = create_tween()
	tween.set_loops( 2 )
	tween.tween_property( player, "modulate:a", 0.1, 0.1 )
	tween.tween_property( player, "modulate:a", 1.0, 0.1 )
