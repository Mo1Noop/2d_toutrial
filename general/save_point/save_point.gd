@icon("res://general/icons/save_point.svg")
class_name Save_Point extends Node2D

@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect( _on_player_entered )
	area_2d.body_exited.connect( _on_player_exited )

func _on_player_entered( _body : Node2D ) -> void:
	Messages.player_interacted.connect( _on_player_interacted )
	Messages.input_hint_changed.emit( "interact" )


func _on_player_exited( _body : Node2D ) -> void:
	Messages.player_interacted.disconnect( _on_player_interacted )
	Messages.input_hint_changed.emit( "" )


func _on_player_interacted( _player : Player ) -> void:
	Messages.player_healed.emit( 999 )
	SaveManager.save_game()
	
	animation_player.seek( 0.0)
	animation_player.play("game_saved")
	
