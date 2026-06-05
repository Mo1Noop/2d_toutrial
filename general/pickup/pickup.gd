@abstract
class_name Pickup extends CharacterBody2D

@export var pickup_audio : AudioStream
@export var bounce_audio : AudioStream

@export var bounce_count : int = 6
@export var bounciness : float = 0.5


func _ready() -> void:
	for c in get_children():
		if c is Area2D:
			c.body_entered.connect( on_player_entered, CONNECT_ONE_SHOT )
			break


func _physics_process( delta: float ) -> void:
	if bounce_count <= 0: return
	velocity += get_gravity() * delta
	var coll : KinematicCollision2D = move_and_collide( velocity * delta )
	if coll:
		bounce_count -= 1
		#Audio.bounce.play()
		Audio.play_apatial_sound( bounce_audio, global_position )
		velocity = velocity.bounce( coll.get_normal() ) * bounciness
		velocity.x *= bounciness


func on_player_entered( n : Node2D ) -> void:
	if n is Player:
		on_pickup( n )
		Audio.play_apatial_sound( pickup_audio, global_position )
		queue_free()


@abstract func on_pickup( p : Player ) -> void
