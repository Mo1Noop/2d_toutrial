class_name Light_Flicker extends PointLight2D

@export var flicker_intensity : float = 0.2
@export var flicker_frequency : float = 0.1
var og_energy : float = 1.0


func _ready() -> void:
	og_energy = energy
	Flicker()


func Flicker() -> void:
	var new_value : float = randf_range(-1 , 1) * flicker_intensity
	energy = og_energy + new_value
	await get_tree().create_timer( randf_range( 0.2, 0.8 ) ).timeout
	Flicker()
