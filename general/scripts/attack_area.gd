@icon("res://general/icons/attack_area.svg")
class_name Attack_Area extends Area2D

@export var damge : float = 10.0

func _ready() -> void:
	area_entered.connect( on_body_entered )
	body_entered.connect( on_body_entered )
	visible = false
	monitorable = false
	monitoring = false
	


func on_body_entered( body : Node2D ) -> void:
	if body is Damege_area:
		var pos: Vector2 = global_position
		pos.x = body.global_position.x
		VisualEffects.hit_dust( pos )
		body.take_damge( self )


func activate( duration : float = 0.1 ) -> void:
	set_active()
	await get_tree().create_timer( duration ).timeout
	set_active( false )
	
	


func set_active( val : bool = true ) -> void:
	monitoring = val
	visible = val


func flip( dir_x : float ) -> void:
	if dir_x > 0.0:
		scale = Vector2(1,1)
	elif dir_x < 0.0:
		scale = Vector2(-1,-1)
