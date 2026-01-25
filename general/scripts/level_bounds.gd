@tool
@icon( "res://general/icons/level_bounds.svg" )
class_name Level_bounds extends Node2D

@export_range( 480, 2048, 32, "suffix:px" ) var width : int = 480 : set = _on_width_changed
@export_range( 270, 2048, 32, "suffix:px" ) var hieght : int = 270 : set = _on_hieght_changed


func _ready() -> void:
	z_index = 256
	if Engine.is_editor_hint():
		return
	var camera : Camera2D = null
	
	while not camera:
		await get_tree().physics_frame
		camera = get_viewport().get_camera_2d()
	
	camera.limit_left = int( global_position.x )
	camera.limit_top = int( global_position.y )
	camera.limit_right = int( global_position.x ) + width
	camera.limit_bottom = int( global_position.y ) + hieght


func _draw() -> void:
	if Engine.is_editor_hint():
		var r : Rect2 = Rect2( Vector2.ZERO, Vector2( width, hieght ) )
		draw_rect( r, Color(1.0, 1.0, 1.0, 1.0), false, 3 )
		draw_rect( r, Color(1.0, 0.073, 0.0, 1.0), false, 1 )


func _on_width_changed( new_width : int ) -> void:
	width = new_width
	queue_redraw()

func _on_hieght_changed( new_hieght : int ) -> void:
	hieght = new_hieght
	queue_redraw()
