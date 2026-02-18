@icon("res://general/icons/tools.svg")
class_name Level_Tools extends Node2D

#region New Code Region
#const DOOR = preload("uid://c4uij8a7sypr6")
#const SWITCH = preload("uid://etjmo3fl6y3p")
#const LEVEL_TRANSTION = preload("uid://dmxv6s0l2ajl1")
#const PLAYER_SPAWN = preload("uid://c8d25lw8s4a2j")
#const SAVE_POINT = preload("uid://cvma0iqwvxk06")
#const LevelBounds = preload("uid://cbjs6k8batccp")
#const AttackArea = preload("uid://cns0lapeysi1i")
#const DamgeArea = preload("uid://x1to7vuav48n")
#
#
## ====== Inspector Toggles ======
#@export var add_door: bool = false
#@export var add_switch: bool = false
#@export var add_level_transition: bool = false
#@export var add_player_spawn: bool = false
#@export var add_save_point: bool = false
#@export var add_LevelBounds: bool = false
#@export var add_AttackArea: bool = false
#@export var add_DamgeArea: bool = false
#
## ====== Button ======
#@export_tool_button("Add Selected Tools")
#var add_tools_button := _add_selected_tools
#
#
#func _add_selected_tools():
	#print("spidvsjdv")
	#if add_door:
		#add_child(DOOR.instantiate())
#
	#if add_switch:
		#add_child(SWITCH.instantiate())
#
	#if add_level_transition:
		#add_child(LEVEL_TRANSTION.instantiate())
#
	#if add_player_spawn:
		#print("added player spawn")
		#var n = PLAYER_SPAWN.instantiate()
		#add_child(n)
		#n.owner = get_tree().edited_scene_root
		#n.name = "player_spawn"
#
	#if add_save_point:
		#add_child(SAVE_POINT.instantiate())
	#
	#if add_LevelBounds:
		#var l = LevelBounds.new()
		#add_child( l )
		#l.name = "level bounds"
		#l.owner = get_tree().edited_scene_root
	#
	#if add_AttackArea:
		#add_child( AttackArea.new() )
	#
	#if add_DamgeArea:
		#add_child( DamgeArea.new() )
#endregion
