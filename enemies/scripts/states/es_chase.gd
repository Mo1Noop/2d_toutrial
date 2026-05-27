class_name ES_Chase extends Enemy_State

@export var chase_speed : float = 50.0

func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "chase" )


func physics_update( _detla : float ) -> void:
	var dir : Vector2 = blackboard.target.global_position - enemy.global_position
	if dir.y < -1.0 or dir.y > 1.0:
		return
	enemy.change_dir( sign( dir.x ) )
	enemy.velocity.x = sign( dir.x ) * chase_speed
