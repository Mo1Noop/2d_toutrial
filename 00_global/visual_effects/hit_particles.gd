class_name Hit_Particles extends GPUParticles2D


func start( dir : Vector2, settings : Hit_Particle_Settings ) -> void:
	if settings:
		amount = settings.count
		modulate = settings.color
		texture = settings.texture
	process_material.direction = Vector3( dir.x, dir.y, 0.0 )
	emitting = true
	await finished
	queue_free()
