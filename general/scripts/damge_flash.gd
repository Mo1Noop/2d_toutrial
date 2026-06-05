@icon("res://general/icons/hit_flash.svg")
class_name Damge_Flash extends Node

@export var flash_color : Color = Color(1.825, 0.0, 0.0, 1.0)
var tween : Tween

func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect( hit_flash )
	else:
		for c in owner.get_children():
			if c is Damege_area:
				c.damge_taken.connect( hit_flash )
				break


func hit_flash( _a : Attack_Area ) -> void:
	if tween: tween.kill()
	tween = create_tween()
	owner.modulate = flash_color
	tween.tween_property( owner, "modulate", Color.WHITE, 0.3 ).set_delay(0.1)
