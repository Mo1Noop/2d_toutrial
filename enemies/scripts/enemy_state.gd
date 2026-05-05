@icon( "res://general/icons/state.svg" )
class_name Enemy_State extends Node

@export var anim_name : String

var state_machine : Enemy_State_Machine
var enemy : Enemy
var blackboard : Blackboard


func enter() -> void: pass
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _detla : float ) -> void: pass
