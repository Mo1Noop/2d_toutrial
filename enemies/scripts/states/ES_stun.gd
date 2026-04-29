class_name ES_Stun extends Enemy_State


@export var knockback_strength : float = 100.0
var vel_x : float = 0.0
var duration : float = 0.0
var timer : float = 0.0
var twen : Tween


func start() -> void:
	var anim : String = anim_name if anim_name else "stun"
	if enemy.animation.current_animation == anim:
		enemy.animation.seek( 0.0 )
	else:
		enemy.play_animation( anim )
	blink()
	duration = enemy.animation.current_animation_length
	timer = 0.0
	calc_vel( blackboard.damage_source )
	blackboard.damage_source = null
	blackboard.can_decide = false


func enter() -> void:
	start()


func re_enter() -> void:
	start()


func exit() -> void:
	blackboard.can_decide = true


func physics_update( detla : float ) -> void:
	timer += detla
	enemy.velocity.x = vel_x * ( 1 - timer / duration )
	if timer >= duration:
		blackboard.can_decide = true


func calc_vel( a : Attack_Area ) -> void:
	vel_x = 1.0
	if a.global_position.x > enemy.global_position.x:
		vel_x = -1.0
	vel_x *= knockback_strength


func blink() -> void:
	if twen: twen.kill()
	twen = create_tween()
	twen.set_loops( 2 )
	twen.tween_property( enemy.sprite, "modulate:a", 0.4, 0.15 )
	twen.tween_property( enemy.sprite, "modulate:a", 1.0, 0.05 )
	twen.tween_property( enemy.sprite, "modulate:a", 0.4, 0.13 )
	twen.tween_property( enemy.sprite, "modulate:a", 1.0, 0.05 )
