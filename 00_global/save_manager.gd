extends Node #save manager

const scene_01 : String = "uid://cb886t8m51hde" 
const  SLOTS : Array[String] = [ "save_01", "save_02", "save_03" ]

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var presistent_data : Dictionary = {}


func _ready() -> void:
	pass

# for debuging
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_5:
			save_game()
		elif event.keycode == KEY_7:
			load_game()


func create_new_game_save() -> void:
	discovered_areas.append( scene_01 )
	save_data = {
		"scene_path" : scene_01,
		"x" : 60,
		"y" : 230,
		"hp" : 20,
		"max_hp" : 20,
		"dash" : false,
		"double_jump" : false,
		"ground_slam" : false,
		"morph_roll" : false,
		"discovered_areas" : discovered_areas,
		"presistent_data" : presistent_data,
	}
	var save_file = FileAccess.open( get_file_name(), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )


func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path" : SceneManger.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"dash" : player.dash,
		"double_jump" : player.double_jump,
		"ground_slam" : player.ground_slam,
		"morph_roll" : player.morph_roll,
		"discovered_areas" : discovered_areas,
		"presistent_data" : presistent_data,
	}
	var save_file := FileAccess.open( get_file_name(), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )


func load_game() -> void:
	if not FileAccess.file_exists( get_file_name() ):
		return
	var save_file := FileAccess.open( get_file_name(), FileAccess.READ )
	save_data = JSON.parse_string( save_file.get_line() )
	
	presistent_data = save_data.get( "presistent_data", {} )
	discovered_areas = save_data.get( "discovered_areas", [] )
	var scene_path : String = save_data.get( "scene_path", scene_01 )
	SceneManger.transtion_scene( scene_path, "", Vector2.ZERO, "up" )
	await SceneManger.new_scene_ready
	setup_player()


func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = save_data.get( "max_hp", 20 )
	player.hp = save_data.get( "hp", 20 )
	
	player.dash = save_data.get( "dash", false )
	player.double_jump = save_data.get( "double_jump", false )
	player.ground_slam = save_data.get( "ground_slam", false )
	player.morph_roll = save_data.get( "morph_roll", false )
	
	player.global_position = Vector2(
		save_data.get( "x", 0 ),
		save_data.get( "y", 0 )
	)

## returns the name of the save file
func get_file_name() -> String:
	return "user://" + SLOTS[ current_slot ] + ".sav"
