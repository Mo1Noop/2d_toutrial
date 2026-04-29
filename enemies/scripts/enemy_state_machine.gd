@icon( "res://general/icons/state_machine.svg" )
class_name Enemy_State_Machine extends Node

var enemy : Enemy
var blackboard : Blackboard
var states : Array[ Enemy_State ]
var current_state : Enemy_State :
	get():
		return states.front()
var prev_state : Enemy_State:
	get():
		return states.get( 1 )


func setup( e : Enemy, b: Blackboard ) -> void:
	enemy = e
	blackboard = b
	for c in get_children():
		if c is Enemy_State:
			c.enemy = e
			c.blackboard = b
			c.state_machine = self
			states.append( c )
	current_state.enter()


func change_state( new_state : Enemy_State ) -> void:
	if not new_state:
		return
	if new_state == current_state:
		current_state.re_enter()
		return
	if current_state:
		current_state.exit()
	states.push_front( new_state )
	current_state.enter()
	if enemy:
		enemy.decision_engine.current_state = new_state
	states.resize( 2 )


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update( delta )
