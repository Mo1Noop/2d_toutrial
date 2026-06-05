class_name Test_Tool extends OptionButton

## How to use:
## - add your scene path to the array.
## - By default, the selected scene will spawn near the camera center
##   using the "spawn_offset" value.
## - Hold CTRL + Left Mouse Button to create a movable spawn box.
## - Right Mouse Button to delete the box.
## - After selecting a scene, it will spawn at the box position.


@export_file("*.tscn") var scene_path : Array[String]:
	set( val ):
		scene_path = val
		on_scene_set()


@export var spawn_offset : Vector2 = Vector2( 100, -50 )
var current_scene : Node2D
var box : ColorRect
var box_move_speed : float = 1500.0


func _ready() -> void:
	if get_tree().current_scene is CanvasLayer:
		printerr( " can't use this on a CanvasLayer base scene " )
		set_process( false )
		return
	allow_reselect = true
	z_index = 200
	current_scene = get_tree().current_scene
	item_selected.connect( on_item_selected )
	on_scene_set()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tester"):
		grab_focus()


func _process( delta: float ) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and \
				Input.is_key_pressed(KEY_CTRL) and not box:
		box = add_color()
		current_scene.add_child( box )
	
	if box and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		box.queue_free()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and \
			Input.is_key_pressed(KEY_CTRL) and box:
		move_box( delta )


func on_scene_set() -> void:
	clear()
	for i : String in scene_path:
		if i == null: continue
		var scene_name : String = ResourceUID.ensure_path( i )
		add_item( scene_name.get_file().get_basename() )


func on_item_selected( index: int ) -> void:
	release_focus()
	if index < 0 or index >= scene_path.size(): return
	var scene : String = scene_path.get( index )
	if not scene: return
	
	if box:
		spawn( scene, box.global_position )
		return
	
	var cam : Camera2D = get_viewport().get_camera_2d()
	if cam:
		spawn( scene, cam.get_screen_center_position() + spawn_offset )
	else:
		printerr(" can't spawn scene there is no camera use box ")


func spawn( path: String, pos : Vector2 ) -> void:
	var node = load( path ).instantiate()
	current_scene.add_child( node )
	node.global_position = pos
	if box:
		box.queue_free()
		box = null


func add_color() -> ColorRect:
	var _box : ColorRect = ColorRect.new()
	_box.custom_minimum_size = Vector2( 15, 15 )
	_box.color = Color("e74545ff")
	_box.z_index = 200
	return _box


func move_box( delta : float ) -> void:
	box.global_position = box.global_position.move_toward(
		current_scene.get_global_mouse_position() - box.size / 2,
		box_move_speed * delta )
