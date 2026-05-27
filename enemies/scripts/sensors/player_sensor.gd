@icon( "res://general/icons/player_sensor.svg" )
class_name Player_Sensor extends Area2D

signal player_enterd
signal player_exited
signal started_searching

@export var search_duration : float = 2.0
@export var use_audio_sensor : bool = false
@export var audio_detect_dist : float = 350.0
@export var min_audio_sense : float = 0.25

var enemy : Enemy
var timer : float
var player_in_range : bool = false


func _ready() -> void:
	set_collision_mask_value( 1, false )
	set_collision_layer_value( 1, false )
	if owner is Enemy:
		enemy = owner
		set_collision_mask_value( 5, true )
		activate_audio_Sensor( use_audio_sensor )
		body_entered.connect( _on_body_entered )
		body_exited.connect( _on_body_exited )
		enemy.direction_changed.connect( _on_dir_changed )


func activate_audio_Sensor( b : bool ) -> void:
	use_audio_sensor = b
	if use_audio_sensor:
		Audio.player_made_sound.connect( _on_player_sound )


func _physics_process(delta: float) -> void:
	if timer > 0.0 and not player_in_range:
		timer -= delta
		if timer <= 0.0:
			player_exited.emit()
			enemy.blackboard.target = null


func _on_body_entered( body : Node2D ) -> void:
	player_in_range = true
	player_enterd.emit()
	enemy.blackboard.target = body
	var look : Vector2 = enemy.global_position - body.global_position
	enemy.change_dir( -sign(look.x) )
	#print( sign(look.x) )


func _on_body_exited( body : Node2D ) -> void:
	player_in_range = false
	started_searching.emit()
	timer = search_duration
	var look : Vector2 = enemy.global_position - body.global_position
	enemy.change_dir( -sign(look.x) )


func _on_dir_changed( dir : float ) -> void:
	if dir < 0.0: scale.x = -1
	elif dir > 0.0: scale.x = 1

# Michael
#func _on_player_sound( pos : Vector2 , volume : float ) -> void:
	#prints("player made sound ", pos, " | ", volume)
	#var sound_dist : float = global_position.distance_to( pos )
	#var d : float = clampf( 1 - sound_dist / audio_detect_dist, 0.0, 1.0 ) * 2
	#var vol : float = volume * d
	#print( d, " | ", vol )
	#if vol >= min_audio_sense:
		#timer = search_duration
		#enemy.blackboard.target = get_tree().get_first_node_in_group("Player")

# AI Because I am really bad at math
func _on_player_sound(pos: Vector2, volume: float) -> void:
	var sound_dist : float = global_position.distance_to(pos)
	var effective_dist : float = audio_detect_dist * volume
	if effective_dist <= 0.0:
		return
	var d: float = clampf(1.0 - sound_dist / effective_dist, 0.0, 1.0)
	if d >= min_audio_sense:
		timer = search_duration
		enemy.blackboard.target = get_tree().get_first_node_in_group("Player")
