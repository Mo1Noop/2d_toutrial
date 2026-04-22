@icon( "res://general/icons/player_sensor.svg" )
class_name Player_Sensor extends Area2D

signal player_enterd
signal player_exited
signal started_searching

@export var search_duration : float = 2.0

var enemy : Enemy
var timer : float


func _ready() -> void:
	set_collision_mask_value( 1, false )
	set_collision_layer_value( 1, false )
	if owner is Enemy:
		enemy = owner
		set_collision_mask_value( 5, true )
		body_entered.connect( _on_body_entered )
		body_exited.connect( _on_body_exited )
		enemy.direction_changed.connect( _on_dir_changed )
	


func _on_body_entered( body : Node2D ) -> void:
	#timer = search_duration
	player_enterd.emit()
	enemy.blackboard.target = body


func _on_body_exited( _body : Node2D ) -> void:
	started_searching.emit()
	timer = search_duration


func _on_dir_changed( dir : float ) -> void:
	if dir < 0.0: scale.x = -1
	elif dir > 0.0: scale.x = 1


func _physics_process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
		print( "timer: " + str( snapped( timer, 0.01 ) ) )
		if timer <= 0.0:
			player_exited.emit()
			enemy.blackboard.target = null
