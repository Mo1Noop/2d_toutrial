@icon( "res://general/icons/decision_engine.svg" )
class_name Decision_Engine extends Node


var enemy : Enemy
var current_state : Enemy_State
var blackboard : Blackboard

func _ready() -> void:
	while not enemy:
		await get_tree().process_frame
	enemy.change_dir( -1.0 if enemy.face_left_on_start else 1.0 )


func decide() -> Enemy_State:
	return null
