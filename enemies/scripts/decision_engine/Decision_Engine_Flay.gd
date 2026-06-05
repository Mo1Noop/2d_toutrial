class_name Decision_Engine_Flay extends Decision_Engine

@export var es_fly_idle: ES_Fly_Move
@export var es_fly_chase: ES_Fly_Chase
@export var es_fly_attack: ES_Fly_Attack
@export var es_stun: ES_Stun
@export var es_death: ES_Death


func _ready() -> void:
	await super()
	
	pass


func decide() -> Enemy_State:
	if blackboard.damage_source:
		if blackboard.heath <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ES_Death or not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if es_fly_attack.can_attack():
			return es_fly_attack
		return es_fly_chase
	return es_fly_idle
