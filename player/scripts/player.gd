class_name Player extends CharacterBody2D

#region /// var
#const DEBUG = preload("uid://c08vbptobbyb3")

@onready var collision_stand: CollisionShape2D = %CollisionStand
@onready var collision_crouch: CollisionShape2D = %CollisionCrouch
@onready var hero: Sprite2D = %Hero
@onready var player_anim: AnimationPlayer = %PlayerAnim
@onready var one_way_chape_cast: ShapeCast2D = %one_way_chapeCast

@export var move_speed : float = 150
@export var max_fall_velocity : float = 600.0

#endregion

#region /// get states
var states : Array[Player_state]

var current_state : Player_state :
	get : return states.front()
var previous_state : Player_state:
	get : return states[1]
#endregion

#region /// palyer stats
var hp : float = 20 :
	set( value ):
		hp = clampf( value, 0, max_hp )
		Messages.player_helth_changed.emit( hp, max_hp )

var max_hp : float = 20 :
	set( value ):
		max_hp = value
		Messages.player_helth_changed.emit( hp, max_hp )

var dash : bool = false
var double_jump : bool = false
var ground_slam : bool = false
var morph_roll : bool = false
#endregion

#region /// var
var dirction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_mulitplier : float = 1.0

#endregion


func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	initialize_states()
	self.call_deferred( "reparent", get_tree().root )
	Messages.player_healed.connect( _on_player_healed )
	Messages.back_to_title_screen.connect( queue_free )


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit( self )
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu : Pause_Menu = load("res://pause_menu/pause_menu.tscn").instantiate()
		add_child( pause_menu )
		return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_MINUS:
			if Input.is_key_pressed( KEY_SHIFT ):
				max_hp = max( max_hp-10, 0 )
			else:
				hp = max( hp-2, 0 )
		elif event.keycode == KEY_EQUAL:
			if Input.is_key_pressed( KEY_SHIFT ):
				max_hp += 10
			else:
				hp = min( hp+2, max_hp )
	
	change_state( current_state.handle_input(event) )


func _process(delta: float) -> void:
	update_dirction()
	change_state( current_state.process(delta) )


func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.y += gravity * delta * gravity_mulitplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	change_state( current_state.physics_process(delta) )


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


func change_state( new_state : Player_state ) -> void:
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name


func update_dirction() -> void:
	var prev_dirction : Vector2 = dirction
	var x_axis : float = Input.get_axis("left", "right")
	var y_axis : float = Input.get_axis("up", "down")
	dirction = Vector2(x_axis, y_axis)
	
	if prev_dirction.x != dirction.x:
		if dirction.x < 0.0:
			hero.flip_h = true
		elif dirction.x > 0.0:
			hero.flip_h = false


#func debug(color : Color) -> void:
	#var d : Node2D = DEBUG.instantiate()
	#get_tree().root.add_child(d)
	#d.global_position = global_position
	#d.modulate = color
	#await get_tree().create_timer( 2.0 ).timeout
	#d.queue_free()


func move() -> void:
	velocity.x = dirction.x * move_speed


func _on_player_healed( amount : float ) -> void:
	hp += amount
