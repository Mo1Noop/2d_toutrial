@tool
@icon("res://general/icons/door.svg")
class_name Door extends Node2D

const DOOR_CRASH_AUDIO = preload("uid://bd7b3rxms6u4p")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for child in get_children():
		if not child is Switch:
			return
		child.activated.connect( on_switch_activated )
		if child.is_open:
			on_switch_is_open()


func on_switch_activated() -> void:
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
