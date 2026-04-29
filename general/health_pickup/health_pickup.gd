class_name Health_Pickup extends CharacterBody2D

const HEALTH_UP_AUDIO = preload("uid://bbj6cwagd01x6")

@export var heal_amount : float = 1.0
@onready var area_2d: Area2D = $Area2D
var bounce_count : int = 8


func _ready() -> void:
	area_2d.body_entered.connect( on_player_entered )


func _physics_process( delta: float ) -> void:
	if bounce_count > 0:
		velocity += get_gravity() * delta
		var coll : KinematicCollision2D = move_and_collide( velocity * delta )
		if coll:
			bounce_count -= 1
			velocity = velocity.bounce( coll.get_normal() ) * 0.75


func on_player_entered( n : Node2D ) -> void:
	if n is Player:
		n._on_player_healed( heal_amount )
	area_2d.body_entered.disconnect( on_player_entered )
	Audio.play_apatial_sound( HEALTH_UP_AUDIO, global_position )
	queue_free()
