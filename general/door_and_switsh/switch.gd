@icon("res://general/icons/switch.svg")
class_name Switch extends Node2D

signal activated

const DOOR_SWITCH_AUDIO = preload("uid://bndp1mot47f4e")

var is_open : bool = false
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if SaveManager.presistent_data.get_or_add( unique_name(), "closed" ) == "open":
		set_open()
	else:
		area_2d.body_entered.connect( on_player_entered )
		area_2d.body_exited.connect( on_player_exited )


func on_player_entered( _n : Node2D ) -> void:
	Messages.input_hint_changed.emit( "interact" )
	Messages.player_interacted.connect( on_player_interacted )


func on_player_exited( _n : Node2D ) -> void:
	Messages.input_hint_changed.emit( "" )
	Messages.player_interacted.disconnect( on_player_interacted )


func on_player_interacted( _player : Player ) -> void:
	SaveManager.presistent_data[ unique_name() ] = "open"
	activated.emit()
	set_open()



func set_open() -> void:
	is_open = true
	sprite_2d.flip_h = true
	sprite_2d.modulate = Color.GRAY
	area_2d.queue_free()


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	return u_name










#
