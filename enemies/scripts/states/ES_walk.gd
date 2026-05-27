class_name ES_Walk extends Enemy_State


@export var walk_speed : float = 50.0

var left_limit : float
var right_limit : float

func _ready() -> void:
	_set_limits()


func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "walk" )


func physics_update( _detla : float ) -> void:
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	elif enemy.global_position.x <= left_limit and blackboard.dir < 0.0:
		#blackboard.can_idle = true
		enemy.change_dir( 1.0 )
	elif enemy.global_position.x >= right_limit and blackboard.dir > 0.0:
		#blackboard.can_idle = true
		enemy.change_dir( -1.0 )
	enemy.velocity.x = walk_speed * blackboard.dir


func _set_limits() -> void:
	left_limit = owner.global_position.x - 5000.0
	right_limit = owner.global_position.x + 5000.0
	for c in owner.get_children():
		if c is Patrol_Limit:
			if c.side == Side.SIDE_LEFT:
				left_limit = c.global_position.x
			else:
				right_limit = c.global_position.x
