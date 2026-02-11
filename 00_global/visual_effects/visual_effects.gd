#visual_effects
extends Node

const DUST_EFFECT = preload("uid://c4k0cnlt5vcwy")
signal camera_shook( strength : float )

func _creat_dust_effect( pos : Vector2 ) -> dust_effect:
	var dust : dust_effect = DUST_EFFECT.instantiate()
	add_child( dust )
	dust.global_position = pos
	return dust


func jump_dust( pos : Vector2 ) -> void:
	var dust : dust_effect = _creat_dust_effect( pos )
	dust.start( dust_effect.TYPE.JUMP )

func land_dust( pos : Vector2 ) -> void:
	var dust : dust_effect = _creat_dust_effect( pos )
	dust.start( dust_effect.TYPE.LAND )

func hit_dust( pos : Vector2 ) -> void:
	var dust : dust_effect = _creat_dust_effect( pos )
	dust.start( dust_effect.TYPE.HIT )


func hit_particles() -> void:
	pass


func camera_chake( strength : float = 1.0 ) -> void:
	camera_shook.emit( strength )
