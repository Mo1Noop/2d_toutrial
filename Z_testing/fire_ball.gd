class_name FireBall extends CharacterBody2D

@export var move_speed: float = 200.0
@export var gravity_scale: float = 500.0
@export var reset: bool = false

var life_time: float = 3.0
var _launched: bool = false

func _ready() -> void:
	get_tree().create_timer( life_time ).timeout.connect( queue_free )
	launch_toward( Vector2(200, 20) )

func launch_toward(target_position: Vector2) -> void:
	var direction: Vector2 = (target_position - global_position)
	var distance: float = direction.x  # horizontal distance only

	# Tilt the angle based on distance:
	# close target = steep angle, far target = shallow angle
	var base_angle: float = clampf(abs(distance) / 800.0, 0.1, 0.85)
	var vertical_boost: float = -move_speed * base_angle  # negative = upward

	var sign_x: float = sign(direction.x) if direction.x != 0.0 else 1.0
	velocity = Vector2(move_speed * sign_x, vertical_boost)
	_launched = true

func _process(_delta: float) -> void:
	if reset:
		position = Vector2.ZERO
		velocity = Vector2.ZERO
		_launched = false
		reset = false
		launch_toward( Vector2(200, 20) )

func _physics_process(delta: float) -> void:
	if not _launched:
		return

	velocity.y += gravity_scale * delta

	move_and_slide()


#const FIRE_BALL = preload("uid://bv1aalk7rcsfa")
#func fire_ball() -> void:
	#var ball: FireBall = FIRE_BALL.instantiate()
	#add_child(ball)
	#ball.global_position = enemy.global_position
	#ball.launch_toward( blackboard.target.global_position )
