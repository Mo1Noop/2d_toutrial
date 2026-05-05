class_name ES_Attack extends Enemy_State

@export var attack_range : float = 100.0
@export var move_speed : float = 5.0
@export var cooldown : float = 3.0
@export var attack_area: Attack_Area

var timer : float = 0.0
var duration : float = 0.0
var on_cooldown : bool = false


func enter() -> void:
	enemy.play_animation( anim_name if anim_name else "attack" )
	duration = enemy.animation.current_animation_length
	timer = 0.0
	on_cooldown = true
	blackboard.can_decide = false
	enemy.velocity.x = move_speed * blackboard.dir
	if attack_area:
		attack_area.flip( blackboard.dir )


func exit() -> void:
	blackboard.can_decide = true
	run_cooldown()


func physics_update( detla : float ) -> void:
	timer += detla
	if timer >= duration:
		blackboard.can_decide = true


func can_attack() -> bool:
	if blackboard.distance_to_target <= attack_range\
		and not on_cooldown:
		return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
