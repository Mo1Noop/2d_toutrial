class_name ES_idle extends Enemy_State


func enter() -> void:
	blackboard.can_decide = false
	
	await get_tree().create_timer( 0.5 ).timeout
	enemy.change_dir( -blackboard.dir )
	await get_tree().create_timer( 0.5 ).timeout
	
	blackboard.can_decide = true


func physics_update( _detla : float ) -> void:
	enemy.velocity.x = 0.0
