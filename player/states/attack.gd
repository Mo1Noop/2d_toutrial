class_name PlayerState_attack extends Player_state

const AUDIO_ATTACK = preload("uid://x687f3ppy68d")

@export var combo_time_window : float = 0.2
@export var speed : float = 75.0
var timer : float = 0
var combo : int = 0

@onready var attack_sprite: Sprite2D = %attack_sprite

func init() -> void:
	attack_sprite.visible = false


func enter() -> void:
	do_attack()
	player.player_anim.animation_finished.connect( on_anim_finished )


func exit() -> void:
	timer = 0.0
	combo = 0
	player.player_anim.animation_finished.disconnect( on_anim_finished )
	next_state = null

func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("attack"):
		timer = combo_time_window
	
	return next_state


func process( delta: float ) -> Player_state:
	timer -= delta
	return next_state


func physics_process(_delta: float) -> Player_state:
	player.velocity.x = player.dirction.x * speed
	return null


func do_attack() -> void:
	var anim_name : String = "attack"
	if combo > 0.0:
		anim_name = "attack_2"
	player.player_anim.play( anim_name )
	player.attack_area.activate()
	Audio.play_apatial_sound( AUDIO_ATTACK, player.global_position )

func end_attack() -> void:
	if timer > 0.0:
		combo = wrapi( combo + 1, 0, 2 )
		do_attack()
	else:
		next_state = idle

func on_anim_finished( _anim_name : String ) -> void:
	end_attack()
