@icon( "res://general/icons/edge_sensor.svg" )
class_name Edge_Sensor extends RayCast2D

signal edge_detected

var enemy : Enemy
var colliding : bool = true

func _ready() -> void:
	set_collision_mask_value( 1, true )
	set_collision_mask_value( 2, true )
	if owner is Enemy:
		enemy = owner
		enemy.direction_changed.connect( dir_changed )
	else:
		set_physics_process( false )
		enabled = false

func _physics_process(_delta: float) -> void:
	if not enemy.is_on_floor():
		return
	
	var _is_colliding : bool = is_colliding()
	
	if colliding != _is_colliding:
		colliding = _is_colliding
		if not colliding:
			enemy.blackboard.edge_detected = true
			edge_detected.emit()
		else:
			enemy.blackboard.edge_detected = false


func dir_changed( new_dir : float ) -> void:
	if sign(new_dir) != sign(position.x):
		position.x *= -1
