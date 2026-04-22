@tool
@icon( "res://general/icons/enemy.svg" )
class_name Enemy extends CharacterBody2D

signal direction_changed( new_dir : float )
signal was_hit( a : Attack_Area )
signal was_killed()

@export var health : float = 3.0
@export var affected_by_gravity : bool = true
@export var face_left_on_start : bool = false

var sprite : Sprite2D
var animation : AnimationPlayer
var damage_area : Damege_area
var hazard_area : Hazard_Area

var state_machine : Enemy_State_Machine
var decision_engine : Decision_Engine
var blackboard : Blackboard


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process( false )
		return
	setup()


func setup() -> void:
	blackboard = Blackboard.new()
	blackboard.heath = health
	
	for c in get_children():
		if c is AnimationPlayer and not animation:
			animation = c
		elif c is Sprite2D and not sprite:
			sprite = c 
		elif c is Damege_area and not damage_area:
			damage_area = c
			damage_area.damge_taken.connect( on_damge_taken ) 
		elif c is Hazard_Area and not hazard_area:
			hazard_area = c 
		elif c is Enemy_State_Machine and not state_machine:
			state_machine = c 
		elif c is Decision_Engine and not decision_engine:
			decision_engine = c 
	
	if state_machine and decision_engine:
		state_machine.setup( self, blackboard )
		decision_engine.enemy = self
		decision_engine.blackboard = blackboard
	else:
		set_physics_process( false )


func _physics_process( delta: float ) -> void:
	blackboard.update_distance_to_target( global_position )
	state_machine.change_state( decision_engine.decide() )
	if affected_by_gravity:
		velocity += get_gravity() * delta
	state_machine.physics_update( delta )
	move_and_slide()


func change_dir( new_dir : float ) -> void:
	blackboard.dir = new_dir
	direction_changed.emit( new_dir )
	if sprite:
		if new_dir < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false


func play_animation( anim_name : String ) -> void:
	if animation.has_animation( anim_name ):
		animation.play( anim_name )
	else:
		printerr( "Animation Messing: " , anim_name )


func on_damge_taken( a : Attack_Area ) -> void:
	blackboard.damage_source = a
	blackboard.heath -= a.damge
	if blackboard.heath <= 0:
		damage_area.queue_free()
		hazard_area.queue_free()
		was_killed.emit()
	was_hit.emit( a )


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	
	if not find_children( "*", "Sprite2D", false ):
		warnings.append( "Requires an Sprite2D!" )
	if not find_children( "*", "AnimationPlayer", false ):
		warnings.append( "Requires an AnimationPlayer!" )
	if not find_children( "*", "Damege_area", false ):
		warnings.append( "Requires an Damege_area!" )
	if not find_children( "*", "Hazard_Area", false ):
		warnings.append( "Requires an Hazard_Area!" )
	if not find_children( "*", "Enemy_State_Machine", false ):
		warnings.append( "Requires an Enemy_State_Machine!" )
	if not find_children( "*", "Decision_Engine", false ):
		warnings.append( "Requires an Decision_Engine!" )
	
	return warnings
