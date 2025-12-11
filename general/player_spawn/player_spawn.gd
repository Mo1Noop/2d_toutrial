@icon("res://general/icons/player_spawn.svg")
class_name Player_spawn extends Node2D


func _ready() -> void:
	visible = false
	await get_tree().process_frame
	if get_tree().get_first_node_in_group("Player"):
		return
	var player : Player = load("uid://gwcdq2kv6ci2").instantiate()
	get_tree().root.add_child(player)
	player.global_position = self.global_position
	
