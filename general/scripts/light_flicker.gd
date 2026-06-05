class_name Light_Flicker extends PointLight2D

@export var flicker_intensity : float = 0.6
@export var flicker_frequency : float = 0.6
@onready var timer: Timer = $Timer
var og_energy : float
var tween : Tween

func _ready() -> void:
	og_energy = energy
	timer.timeout.connect( Flicker )
	timer.start()


func Flicker() -> void:
	var rand : float = randf_range(flicker_frequency * -0.5,flicker_frequency * 0.5)
	var new_value : float = (randf_range(-1, 1) * flicker_intensity) + og_energy
	var duration : float = flicker_frequency + rand
	
	if tween: tween.kill()
	tween = create_tween()
	new_value = clampf( new_value, 0.8, 2 )
	tween.tween_property(self, "energy", new_value, duration * 0.5 )
	
	timer.wait_time = duration
	timer.start()
