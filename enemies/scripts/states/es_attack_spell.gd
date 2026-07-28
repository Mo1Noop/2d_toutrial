class_name ES_Attack_Spell extends ES_Attack


@export var cast_duration : float = 1.0
@export_file( "*.tscn" ) var  spell_scene : String

func enter() -> void:
	super()
	duration = cast_duration
	var spell : Doom_Scrib_Spell = load( spell_scene ).instantiate()
	if spell and blackboard.target:
		blackboard.target.add_child( spell )
		spell.set_enemy( enemy )
		spell.position.y = -48
