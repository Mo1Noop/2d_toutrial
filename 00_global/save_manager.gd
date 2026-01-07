extends Node #save manager

const scene_01 : String = "uid://cb886t8m51hde" 
const  SLOTS : Array[String] = [ "save_01", "save_02", "save_03" ]

var current_slot : int = 0
var game_data : Dictionary
var discovered_areas : Array = []
var presistent_data : Dictionary = {}

func _ready() -> void:
	SceneManger.scene_entered.connect( on_scene_entered )

# for debuging
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_5:
			save_game()
		elif event.keycode == KEY_7:
			load_game( current_slot )


func create_new_game_save( slot : int ) -> void:
	current_slot = slot
	discovered_areas.clear()
	presistent_data.clear()
	
	discovered_areas.append( scene_01 )
	game_data = {
		"scene_path" : scene_01,
		"x" : 100,
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
	var save_file = FileAccess.open( get_file_name( current_slot ), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( game_data ) )
	save_file.close()
	load_game( slot )


func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	game_data = {
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
	var save_file := FileAccess.open( get_file_name( current_slot ), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( game_data ) )


func load_game( slot : int ) -> void:
	current_slot = slot
	if not FileAccess.file_exists( get_file_name( current_slot ) ):
		return
	var save_file := FileAccess.open( get_file_name( current_slot ), FileAccess.READ )
	game_data = JSON.parse_string( save_file.get_line() )
	
	presistent_data = game_data.get( "presistent_data", {} )
	discovered_areas = game_data.get( "discovered_areas", [] )
	var scene_path : String = game_data.get( "scene_path", scene_01 )
	SceneManger.transtion_scene( scene_path, "", Vector2.ZERO, "up" )
	await SceneManger.new_scene_ready
	setup_player()


func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = game_data.get( "max_hp", 20 )
	player.hp = game_data.get( "hp", 20 )
	
	player.dash = game_data.get( "dash", false )
	player.double_jump = game_data.get( "double_jump", false )
	player.ground_slam = game_data.get( "ground_slam", false )
	player.morph_roll = game_data.get( "morph_roll", false )
	
	player.global_position = Vector2(
		game_data.get( "x", 0 ),
		game_data.get( "y", 0 )
	)

## returns the name of the save file
func get_file_name( slot : int ) -> String:
	return "user://" + SLOTS[ slot ] + ".sav"


func save_file_exists( slot : int ) -> bool:
	return FileAccess.file_exists( get_file_name( slot ) )


func is_area_discovered( scene_uid : String ) -> bool:
	return discovered_areas.has( scene_uid )


func on_scene_entered( scene_uid : String ) -> void:
	if discovered_areas.has( scene_uid ):
		return
	else:
		discovered_areas.append( scene_uid )





#
