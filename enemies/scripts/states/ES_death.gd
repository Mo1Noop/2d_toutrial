class_name ES_Death extends Enemy_State


@export var death_sound : AudioStream
@export var knockback_strength : float = 20.0
var vel_x : float = 0.0
var duration : float = 0.0
var timer : float = 0.0


func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "death" )
	Audio.play_apatial_sound( death_sound, enemy.global_position )
	
	duration = enemy.animation.current_animation_length
	timer = 0.0
	calc_vel( blackboard.damage_source )
	blackboard.damage_source = null
	blackboard.can_decide = false
	
	await enemy.animation.animation_finished
	enemy.visible = false
	enemy.queue_free()


func physics_update( detla : float ) -> void:
	timer += detla
	enemy.velocity.x = vel_x * ( 1 - timer / duration )
	if timer > duration:
		blackboard.can_decide = true


func calc_vel( a : Attack_Area ) -> void:
	vel_x = 1.0
	if a.global_position.x > enemy.global_position.x:
		vel_x = -1.0
	vel_x *= knockback_strength
