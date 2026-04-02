class_name playerState_dash extends Player_state

const DASH_AUDIO = preload("uid://bohje3v0cuf8m")

@export var duration : float = 0.25
@export var speed : float = 300.0
@export var effect_delay : float = 0.05

var dash_dir : float = 1.0
var time : float = 0.0
var effect_time : float = 0.0


func enter() -> void:
	#tween_dash()
	player.player_anim.play("dash")
	time = duration
	effect_time = 0.0
	get_dash_dir()
	player.damege_area.make_invurable( duration )
	Audio.play_apatial_sound( DASH_AUDIO, player.global_position )
	player.gravity_mulitplier = 0.0
	player.velocity.y = 0.0
	player.dash_count += 1
	player.hero.tween_color()


func handle_input(_event : InputEvent) -> Player_state:
	if _event.is_action_pressed("action") and player.can_morph():
		return ball
	return null

func exit() -> void:
	player.gravity_mulitplier = 1.0


func process( delta: float ) -> Player_state:
	time -= delta
	if time <= 0.0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_time -= delta
	if effect_time < 0.0:
		effect_time = effect_delay
		player.hero.ghost()
	
	return null

# this change only for fun
func physics_process(_delta: float) -> Player_state:
	var vel : float = ( speed * ( time / duration ) + speed )
	if player.dirction == Vector2.ZERO:
		player.velocity.x = vel * dash_dir
	else:
		player.velocity = vel * player.dirction
	return null


func tween_dash() -> void:
	var tween : Tween = create_tween()
	get_dash_dir()
	tween.tween_property(player,"velocity:x",speed*dash_dir,duration)
	tween.tween_property( player, "velocity:x", 0.0, 0.0 )
	await tween.finished
	tween.kill()


func get_dash_dir() -> void:
	dash_dir = 1.0
	if player.hero.flip_h:
		dash_dir = -1.0
