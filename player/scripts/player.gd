class_name Player extends CharacterBody2D

const DEBUG = preload("uid://c08vbptobbyb3")


#region export var
@export var move_speed : float = 150
@export var jump_velocity : float = -425
#endregion

#region get states
var states : Array[Player_state]

var current_state : Player_state :
	get : return states.front()
var previous_state : Player_state:
	get : return states[1]
#endregion

#region var
var dirction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_mulitplier : float = 1.0

#endregion


func _ready() -> void:
	initialize_states()
	pass


func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input(event) )


func _process(delta: float) -> void:
	update_dirction()
	change_state( current_state.process(delta) )
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()
	player_gravity(delta)
	change_state( current_state.physics_process(delta) )
	pass


func initialize_states() -> void:
	states = []
	for c in $states.get_children():
		if c is Player_state:
			states.append(c)
			c.player = self
	
	if states.size() == 0:
		return
	
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name
	
	pass


func change_state( new_state : Player_state ) -> void:
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name
	pass


func update_dirction() -> void:
	#var prev_dirction : Vector2 = dirction
	var x_axis : float = Input.get_axis("left", "right")
	var y_axis : float = Input.get_axis("up", "down")
	dirction = Vector2(x_axis, y_axis)
	pass


func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")

func debug(color : Color) -> void:
	var d : Node2D = DEBUG.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 2.0 ).timeout
	d.queue_free()


func move() -> void:
	velocity.x = dirction.x * move_speed

func player_gravity(delta:float) -> void:
	velocity.y += gravity * delta * gravity_mulitplier
