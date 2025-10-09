@icon("res://player/states/state.svg")
class_name Player_state extends Node

var player : Player
var next_state : Player_state


func init() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(_event : InputEvent) -> Player_state:
	return next_state


func process(_delta: float) -> Player_state:
	return next_state


func physics_process(_delta: float) -> Player_state:
	return next_state
