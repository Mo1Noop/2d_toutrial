@tool
@icon("res://general/icons/door.svg")
class_name Door extends Node2D

const DOOR_CRASH_AUDIO = preload("uid://bd7b3rxms6u4p")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var door_size : Vector2 = Vector2( 32, 114 ) :
	set( val ):
		door_size = val
		for c in get_children():
			if c is NinePatchRect:
				c.size.y = door_size.y

@export var floor_position : float = 16 :
	set( val ):
		floor_position = val
		for c in get_children():
			if c is Sprite2D:
				c.position.y = floor_position


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for child in get_children():
		if child is Switch:
			child.activated.connect( on_switch_activated )
			if child.is_open:
				on_switch_is_open()
	set_door_size_value()


func set_door_size_value() -> void:
	animation_player.get_animation("closed").track_set_key_value( 0, 0, door_size )
	animation_player.get_animation("open").track_set_key_value( 0, 0, door_size )


func on_switch_activated() -> void:
	Audio.play_apatial_sound( DOOR_CRASH_AUDIO, global_position )
	animation_player.play( "open" )


func on_switch_is_open() -> void:
	animation_player.play( "opened" )


func _get_configuration_warnings() -> PackedStringArray:
	if not check_for_switch():
		return [ "Requires a Switch node" ]
	return []


func check_for_switch() -> bool:
	for c in get_children():
		if c is Switch:
			return true
	return false




#
