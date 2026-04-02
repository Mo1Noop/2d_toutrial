@icon( "res://general/icons/enemy.svg" )
class_name Slime extends CharacterBody2D

@export var health : float = 3.0
@export var move_speed : float = 30.0
@export var face_left_on_start : bool = false
@export var death_audio : AudioStream

var dir : float = 1.0
var move_tween : Tween

@onready var slime_sprite: Sprite2D = $Slime_Sprite
@onready var anim_player: AnimationPlayer = $AnimPlayer
@onready var damege_area: Damege_area = $Damege_area
@onready var hazard_area: Hazard_Area = $Hazard_Area
@onready var edge_detector: Edge_Detector = $Edge_Detector


func _ready() -> void:
	edge_detector.edge_detected.connect( on_edge_detected )
	damege_area.damge_taken.connect( on_damge_taken )
	anim_player.animation_finished.connect( on_animation_finished )
	#change_dir( -1.0 if face_left_on_start else 1.0 )
	if face_left_on_start:
		change_dir( -1.0 )
	else:
		change_dir( 1.0 )


func _physics_process(delta: float) -> void:
	if is_on_wall():
		change_dir( -dir )
	
	velocity += get_gravity() * delta
	velocity.x = dir * move_speed
	move_and_slide()


func change_dir( new_dir : float ) -> void:
	dir = new_dir
	edge_detector.dir_changed( dir )

	if dir > 0.0:
		slime_sprite.flip_h = false
	elif dir < 0.0:
		slime_sprite.flip_h = true


func on_edge_detected() -> void:
	if is_on_floor():
		change_dir( -dir )


func on_damge_taken( attack_area : Attack_Area ) -> void:
	health -= attack_area.damge
	
	if health > 0.0:
		anim_player.play("stun")
	else:
		dir = 0.0
		anim_player.play("death")
		Audio.play_apatial_sound( death_audio, global_position )
		damege_area.queue_free()
		hazard_area.queue_free()
	
	knockback( attack_area.global_position )


func on_animation_finished( anim_name : String ) -> void:
	if anim_name == "stun":
		anim_player.play("walk")
	else:
		queue_free()


func knockback( pos : Vector2 ) -> void:
	if move_tween:
		move_tween.kill()
	var new_dir : float = dir 
	var old_dir : float = dir
	
	if pos.x < global_position.x:
		new_dir += 2.0
	else:
		new_dir -= 2.0
	dir = new_dir
	
	move_tween = create_tween()
	move_tween.tween_property( self, "dir", old_dir, 0.3 )
