class_name ES_Fly_Attack extends Enemy_State

@export var attack_range : float = 100.0
@export var cooldown : float = 2.0
@export var attack_speed : float = 200.0
@export var attack_area: Attack_Area
@export var move_speed_curve : Curve


var dir : Vector2
var timer : float = 0.0
var duration : float = 0.0
var on_cooldown : bool = false
var speed_sample : float = 1.0

func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "attack" )
	duration = enemy.animation.current_animation_length
	timer = 0.0
	blackboard.can_decide = false
	on_cooldown = true
	if attack_area:
		attack_area.flip( blackboard.dir )


func exit() -> void:
	blackboard.can_decide = true
	run_cooldown()


func physics_update( detla : float ) -> void:
	timer += detla
	if timer >= duration:
		blackboard.can_decide = true
	if move_speed_curve:
		speed_sample = move_speed_curve.sample( timer / duration )
	dir = enemy.global_position.direction_to( blackboard.target.global_position )
	enemy.change_dir( sign( dir.x ) )
	enemy.velocity = dir * attack_speed * speed_sample


func can_attack() -> bool:
	if blackboard.distance_to_target <= attack_range\
		and not on_cooldown:
		return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
