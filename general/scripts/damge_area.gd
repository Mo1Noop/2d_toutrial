@icon("res://general/icons/damage_area.svg")
class_name Damege_area extends Area2D

signal damge_taken( attake_area : Attack_Area )

@export var audio : AudioStream

func take_damge( attake_area : Attack_Area ) -> void:
	damge_taken.emit( attake_area )
	if audio:
		Audio.play_apatial_sound( audio, global_position )


func make_invurable( duration : float = 1.0 ) -> void:
	start_invurable()
	await get_tree().create_timer( duration ).timeout
	end_invurable()


func start_invurable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func end_invurable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
