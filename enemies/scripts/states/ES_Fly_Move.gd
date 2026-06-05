class_name ES_Fly_Move extends Enemy_State

@export var speed : float = 50.0

var left_limit : float
var right_limit : float

func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "fly" )
	set_limit()


func re_enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update( _detla : float ) -> void:
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	elif enemy.global_position.x <= left_limit and blackboard.dir < 0.0:
		enemy.change_dir( 1.0 )
	elif enemy.global_position.x >= right_limit and blackboard.dir > 0.0:
		enemy.change_dir( -1.0 )
	enemy.velocity = Vector2( speed * blackboard.dir, 0 )


func set_limit() -> void:
	left_limit = owner.global_position.x - 5000
	right_limit = owner.global_position.x + 5000
	if enemy.patrol_limit_L and enemy.patrol_limit_R:
		left_limit = enemy.patrol_limit_L.global_position.x
		right_limit = enemy.patrol_limit_R.global_position.x
