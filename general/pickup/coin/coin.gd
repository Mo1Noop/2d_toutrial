class_name Coins_Pickup extends Pickup


func on_pickup( p : Player ) -> void:
	p.coin += 1
