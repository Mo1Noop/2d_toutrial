class_name Decision_Engine_Basic extends Decision_Engine

@onready var es_walk: ES_Walk = %ES_Walk
@onready var es_stun: ES_Stun = %ES_Stun
@onready var es_death: ES_Death = %ES_Death
@onready var es_idle: ES_idle = %ES_idle


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
	
	if blackboard.edge_detected:
		enemy.change_dir( -blackboard.dir )
		#return es_idle
	
	return es_walk
