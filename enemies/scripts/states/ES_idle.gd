class_name ES_idle extends Enemy_State


func enter() -> void:
	enemy.velocity.x = lerp( enemy.velocity.x, 0.0, 0.6 )
	blackboard.can_decide = false
	await get_tree().create_timer( 0.5 ).timeout
	enemy.change_dir( -blackboard.dir )
	blackboard.can_decide = true
	blackboard.can_idle = false
