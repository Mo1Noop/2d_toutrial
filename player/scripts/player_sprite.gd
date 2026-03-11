class_name Player_Sprite extends Sprite2D

var tween : Tween
@export var effect_color : Color = Color(0.0, 1.0, 0.95, 1.0)

func tween_color( duration : float = 0.5, color : Color = effect_color ) -> void:
	if tween:
		tween.kill()
	modulate = color
	tween = create_tween()
	tween.tween_property( self, "modulate", Color.WHITE, duration )


func ghost() -> void:
	var effect : Node2D = Node2D.new()
	var p : Node2D = get_parent()
	p.add_sibling( effect )
	effect.get_parent().move_child( effect, 0 )
	effect.z_index = 1
	effect.global_position = p.global_position
	effect.modulate = effect_color
	
	var sprite_copy : Sprite2D = duplicate()
	effect.add_child( sprite_copy )
	
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property( effect, "modulate:a", 0.0, 0.2 )
	t.chain().tween_callback( effect.queue_free )
