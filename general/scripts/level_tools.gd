@tool
@icon("res://general/icons/tools.svg")
class_name Level_Tools extends Node2D

#region preload
const DOOR = preload("uid://c4uij8a7sypr6")
const SWITCH = preload("uid://etjmo3fl6y3p")
const LEVEL_TRANSTION = preload("uid://dmxv6s0l2ajl1")
const PLAYER_SPAWN = preload("uid://c8d25lw8s4a2j")
const SAVE_POINT = preload("uid://cvma0iqwvxk06")
const LEVELBOUNDS = preload("uid://cbjs6k8batccp")
const AttackArea = preload("uid://cns0lapeysi1i")
const DamgeArea = preload("uid://x1to7vuav48n")
#endregion

enum TOOLS { ADD, ADD2 }
@export var  tools : TOOLS = TOOLS.ADD : set = _add_selected_tools

#region Inspector Toggles
@export_group("tools")
@export var add_door: bool = false
@export var add_switch: bool = false
@export var add_level_transition: bool = false
@export var add_player_spawn: bool = false
@export var add_save_point: bool = false
@export var add_LevelBounds: bool = false
@export var add_AttackArea: bool = false
@export var add_DamgeArea: bool = false
#endregion

func _add_selected_tools( val ):
	if not Engine.is_editor_hint(): return
	tools = val
	print("add selected tools")
	if add_door: spowne( DOOR )
	if add_switch: spowne( SWITCH )
	if add_level_transition: spowne(LEVEL_TRANSTION)
	if add_player_spawn: spowne( PLAYER_SPAWN )
	if add_save_point: spowne(SAVE_POINT)
	if add_LevelBounds: spowne( LEVELBOUNDS )
	if add_AttackArea: spowne( AttackArea )
	if add_DamgeArea: spowne( DamgeArea )

func spowne( scene ) -> void:
	if not Engine.is_editor_hint(): return
	var s : Variant
	if scene is PackedScene: s = scene.instantiate()
	elif scene is GDScript: s = scene.new()
	else: printerr(" Unsupported type ")
	add_child( s, true )
	s.owner = get_tree().edited_scene_root

#endregion
