class_name Health_Pickup extends Pickup

@export var heal_amount : float = 1.0

func on_pickup( p : Player ) -> void:
	p.on_player_healed( heal_amount )
