class_name ES_Fly_Chase extends Enemy_State

var chace_speed : float = 75.0

func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "chace" )


func physics_update( _detla : float ) -> void:
	var dir : Vector2 = enemy.global_position.direction_to( blackboard.target.global_position )
	enemy.change_dir( sign( dir.x ) )
	enemy.velocity = chace_speed * dir
