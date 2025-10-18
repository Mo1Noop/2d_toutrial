@icon("res://player/states/state.svg")
class_name Player_state extends Node

var player : Player
var next_state : Player_state

#region state references
@onready var idle: PlayerState_Idle = %idle
@onready var run: PlayerState_Run = %run
@onready var jump: PlayerState_jump = %jump
@onready var fall: PlayerState_fall = %fall
@onready var crouch: PlayerState_crouch = %crouch
@onready var hover: playerState_hover = %hover

#endregion


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
