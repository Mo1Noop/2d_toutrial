extends VBoxContainer

@onready var ability_double_jump: TextureRect = %ability_double_jump
@onready var ability_dash: TextureRect = %ability_dash
@onready var ability_ground_slam: TextureRect = %ability_ground_slam
@onready var ability_morph_roll: TextureRect = %ability_morph_roll

func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	ability_dash.visible = player.dash
	ability_double_jump.visible = player.double_jump
	ability_morph_roll.visible = player.morph_roll
	ability_ground_slam.visible = player.ground_slam
