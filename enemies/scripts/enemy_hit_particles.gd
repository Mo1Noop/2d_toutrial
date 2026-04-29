@icon( "res://general/icons/enemy_hit_particles.svg" )
class_name Enemy_Hit_Particles extends Marker2D

@export var hit_particles : Array[ Hit_Particle_Settings ]
@export var death_particles : Array[ Hit_Particle_Settings ]

var enemy_was_killed : bool = false

func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect( _on_hit )
		owner.was_killed.connect( _on_killed )
	else:
		for c in get_parent().get_children():
			if c is Damege_area:
				c.damge_taken.connect( _on_hit )


func _on_hit( a :Attack_Area ) -> void:
	var dir : Vector2 = global_position.direction_to( a.global_position )
	var particles = hit_particles
	dir.x *= -1
	if enemy_was_killed:
		particles = death_particles
	for p in particles:
		VisualEffects.hit_particles( global_position, dir, p )


func _on_killed() -> void:
	enemy_was_killed = true
