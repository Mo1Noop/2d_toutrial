class_name PlayerState_ground_slam extends Player_state

const BOOM_AUDIO = preload("uid://qn1dhtflok0g")
const BREAK_WOOD_AUDIO = preload("uid://f7ssp5cprx37")
const HIT_WOOD_LARGE = preload("uid://bhqt5d2enq3p7")
const HIT_WOOD_MEDUIM = preload("uid://uhbpmjdbj466")
const HIT_WOOD_SMALL = preload("uid://cmkwibqb2tcg3")

@onready var ground_slam_chape_cast: ShapeCast2D = %ground_slam_chapeCast
@onready var ground_slam_attack_area: Attack_Area = %ground_slam_Attack_Area
@export var velocity : float = 550.0
@export var effect_delay : float = 0.075
var effect_timer : float = 0.0


func enter() -> void:
	player.player_anim.play("ground_slam")
	player.hero.tween_color()
	Audio.play_apatial_sound( dash.DASH_AUDIO, player.global_position )
	player.damege_area.start_invurable()
	ground_slam_attack_area.set_active()


func exit() -> void:
	VisualEffects.camera_chake( 10.0 )
	VisualEffects.land_dust( player.global_position )
	VisualEffects.hit_dust( player.global_position )
	Audio.play_apatial_sound( BOOM_AUDIO, player.global_position )
	player.damege_area.end_invurable()
	ground_slam_attack_area.set_active( false )


func handle_input(_event : InputEvent) -> Player_state:
	return null


func process(delta: float) -> Player_state:
	check_collision( delta )
	effect_timer -= delta
	if effect_timer < 0:
		effect_timer = effect_delay
		player.hero.ghost()
	return null


func physics_process(_delta: float) -> Player_state:
	player.velocity = Vector2( 0.0, velocity )
	if player.is_on_floor():
		if not check_collision(_delta):
			return idle
	return null


func check_collision( delta : float ) -> bool:
	ground_slam_chape_cast.target_position.y = velocity * delta
	ground_slam_chape_cast.force_shapecast_update()
	if not ground_slam_chape_cast.is_colliding():
		return false
	for i in ground_slam_chape_cast.get_collision_count():
		var c = ground_slam_chape_cast.get_collider( i )
		var pos : Vector2 = ground_slam_chape_cast.get_collision_point(i)
		VisualEffects.hit_dust( pos )
		VisualEffects.camera_chake( 10.0 )
		
		if c.get_parent() is Breakable:
			var b : Breakable = c.get_parent()
			Audio.play_apatial_sound( b.destroy_audio, pos )
			for p in b.destroy_particles:
				VisualEffects.hit_particles( pos, Vector2.DOWN, p )
			b.queue_free()
		else:
			VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_LARGE )
			VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_MEDUIM )
			VisualEffects.hit_particles( pos, Vector2.UP, HIT_WOOD_SMALL )
			Audio.play_apatial_sound( BREAK_WOOD_AUDIO, pos )
			SceneManger.add_to_presistent_data( c )
			c.queue_free()
	return true
