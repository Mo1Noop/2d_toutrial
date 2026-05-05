class_name ES_Walk extends Enemy_State


@export var walk_speed : float = 50.0


func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "walk" )


func physics_update( _detla : float ) -> void:
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	enemy.velocity.x = walk_speed * blackboard.dir
