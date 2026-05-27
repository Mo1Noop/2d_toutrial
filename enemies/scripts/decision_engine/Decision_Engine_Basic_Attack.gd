class_name Decision_Engine_Basic_Attack extends Decision_Engine

@onready var es_walk: ES_Walk = %ES_Walk
@onready var es_stun: ES_Stun = %ES_Stun
@onready var es_death: ES_Death = %ES_Death

@export var es_attack: ES_Attack
@export var es_chase: Enemy_State

func _ready() -> void:
	await super()


func decide() -> Enemy_State:
	if blackboard.damage_source:
		if blackboard.heath <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ES_Death or not blackboard.can_decide:
		return null
	
	if blackboard.edge_detected and current_state != es_chase:
		enemy.change_dir( -blackboard.dir )
	
	if blackboard.target:
		if es_attack.can_attack():
			return es_attack
		return es_chase
	return es_walk
