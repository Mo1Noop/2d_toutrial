@tool
@icon("res://general/icons/ability_pickup.svg")
class_name Abillty_Pickup extends Node2D

enum TYPE { DASH, MORPH_ROLL, DOUBLE_JUMP, GROUND_SLAM }

@onready var abillty_anim: AnimationPlayer = %abillty_anim
@onready var orb_anim: AnimationPlayer = %orb_anim
@onready var breakable: Breakable = %Breakable
@onready var orb_sprite: Sprite2D = %orb_sprite

@export var type : TYPE = TYPE.DASH :
	set( val ):
		type = val
		_set_anim()


func _ready() -> void:
	_set_anim()
	if Engine.is_editor_hint():
		return
	
	if SaveManager.presistent_data.get_or_add( get_abillty_name(), "" ) == "colected":
		queue_free()
		return
	breakable.destroyed.connect( on_destroyed )
	breakable.damge_taken.connect( on_hit )


func on_hit() -> void:
	orb_sprite.frame += 1


func on_destroyed() -> void:
	SaveManager.presistent_data[ get_abillty_name() ] = "colected"
	_reward_abillty()
	orb_anim.play("destroy")
	await orb_anim.animation_finished
	queue_free()


func _reward_abillty() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	match type:
		TYPE.DOUBLE_JUMP:
			player.double_jump = true
	match type:
		TYPE.DASH:
			player.dash = true
	match type:
		TYPE.MORPH_ROLL:
			player.morph_roll = true
	match type:
		TYPE.GROUND_SLAM:
			player.ground_slam = true


func _set_anim() -> void:
	if not abillty_anim:
		abillty_anim = %abillty_anim
	abillty_anim.play( get_abillty_name() )


func get_abillty_name() -> String:
	match type:
		TYPE.DOUBLE_JUMP:
			return "double_jump"
		TYPE.DASH:
			return "dash"
		TYPE.MORPH_ROLL:
			return "morph_roll"
		TYPE.GROUND_SLAM:
			return "ground_slam"
	return ""
