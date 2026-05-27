class_name Doom_Scrib_Spell extends Node2D

var damage : float = 10.0


func damage_player() -> void:
	$Attack_Area.activate()
	pass

func set_enemy( e : Enemy ) -> void:
	e.was_killed.connect( queue_free )
