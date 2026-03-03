class_name PlayerState_death extends Player_state

const DEATH_AUDIO = preload("uid://dmkm13q4hqwm1")

func enter() -> void:
	player.player_anim.play("death")
	Audio.play_apatial_sound( DEATH_AUDIO, player.global_position )
	Audio.play_music( null )
	await player.player_anim.animation_finished
	PlayerHud.show_game_over()
	player.damege_area.monitorable = false

func physics_process(_delta: float) -> Player_state:
	player.velocity.x = 0.0
	return null
