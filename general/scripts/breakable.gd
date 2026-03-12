@tool
@icon("res://general/icons/breakable.svg")
class_name Breakable extends Node2D

signal destroyed
signal damge_taken

@export var hp : float = 3.0
@export var fixed_hit_count : bool = false

@export_category("Particles")
@export var emission_offset : Vector2 = Vector2.ZERO
@export var hit_particles : Array[ Hit_Particle_Settings ]
@export var destroy_particles : Array[ Hit_Particle_Settings ]

@export_category("Audio")
@export var hit_audio : AudioStream = preload("uid://bb407knta2dss")
@export var destroy_audio : AudioStream = preload("uid://f7ssp5cprx37")
#@export var reverb : Audio.REVERB_TYPE = Audio.REVERB_TYPE.NONE


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is Damege_area:
			c.damge_taken.connect( on_damge_taken )


func on_damge_taken( attack_area : Attack_Area ) -> void:
	if fixed_hit_count:
		hp -= 1
	else:
		hp -= attack_area.damge
	var pos : Vector2 = global_position + emission_offset
	var dir : Vector2 = Vector2( 1, -1 )
	if attack_area.global_position.x > global_position.x:
		dir.x *= -1
	if hp > 0:
		damge_taken.emit()
		Audio.play_apatial_sound( hit_audio, pos )
		for p in hit_particles:
			VisualEffects.hit_particles( pos, dir, p )
	else:
		destroyed.emit()
		Audio.play_apatial_sound( destroy_audio, pos )
		for p in destroy_particles:
			VisualEffects.hit_particles( pos, dir, p )
		clear_collision()
		var tween : Tween = create_tween()
		tween.tween_property( self, "modulate:a", 0.0, 0.4 )
		tween.finished.connect( queue_free )


func clear_collision() -> void:
	for c in get_children():
		if c is StaticBody2D:
			c.queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_damge_area() == false:
		return ["Requires a DamgeArea node"]
	else:
		return []

func _check_for_damge_area() -> bool:
	for c in get_children():
		if c is Damege_area:
			return true
	return false
