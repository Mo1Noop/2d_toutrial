class_name Player extends CharacterBody2D

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
var speed : float = 200
#endregion

@onready var idle: PlayerState_Idle = $states/idle
@onready var run: PlayerState_Run = $states/run
@onready var jump: PlayerState_jump = $states/jump



func _ready() -> void:
	initialize_states()
	pass


func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input(event) )



func _process(delta: float) -> void:
	change_state( current_state.process(delta) )
	pass


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
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
	
	pass


func change_state( new_state : Player_state ) -> void:
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize(3)
	
	pass


func update_dirction() -> void:
	#var prev_dirction : Vector2 = dirction
	dirction = Input.get_vector( "left", "right", "up", "down" )
	
	pass
