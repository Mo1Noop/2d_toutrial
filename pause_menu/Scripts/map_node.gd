@icon("res://general/icons/map_node.svg")
@tool
class_name Map_Node extends Control

const SCALE_FACTOR : float = 40.0

@export_file("*.tscn") var linked_scene : String : set = on_scene_set
@export_tool_button( "Update" ) var update_node_action = update_node

@export var entranes_top : Array[ float ] = []
@export var entranes_right : Array[ float ] = []
@export var entranes_bottom : Array[ float ] = []
@export var entranes_left : Array[ float ] = []

var indicator_offset : Vector2 = Vector2.ZERO

@onready var label: Label = $Label
@onready var transtion_blocks: Control = %transtion_blocks


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		create_entrance_blocks()
		var linked_scene_UID = ResourceUID.path_to_uid( linked_scene )
		if not SaveManager.is_area_discovered( linked_scene_UID ):
			visible = false
		elif SceneManger.current_scene_uid == linked_scene_UID:
			disblay_player_location()


func on_scene_set( val : String ) -> void:
	if linked_scene != val:
		linked_scene = val
		if Engine.is_editor_hint():
			update_node()


func update_node() -> void:
	var new_size : Vector2 = Vector2( 480, 270 )
	var transtions : Array[ Level_Trensition ] = []
	
	if ResourceLoader.exists( linked_scene ):
		var packed_scene : PackedScene = ResourceLoader.load( linked_scene ) as PackedScene
		if packed_scene:
			var instance = packed_scene.instantiate()
			if instance:
				update_node_label( instance )
				for c in instance.get_children():
					if c is Level_bounds:
						new_size = Vector2( c.width, c.hieght )
						indicator_offset = c.position
					elif c is Level_Trensition:
							transtions.append( c )
				instance.queue_free()
	size = (new_size / SCALE_FACTOR).round()
	create_entrance_data( transtions )
	create_entrance_blocks()



func update_node_label( scene : Node ) -> void:
	if not label:
		label = $Label
	var t : String = scene.scene_file_path
	t = t .replace( "res://levels/", "" )
	t = t.replace( ".tscn", "" )
	label.text = t


func create_entrance_data( transtions : Array[ Level_Trensition ] ) -> void:
	entranes_bottom.clear()
	entranes_top.clear()
	entranes_left.clear()
	entranes_right.clear()
	for t in transtions:
		if t.location == Level_Trensition.SIDE.LEFT:
			var offset : float = clampf(
				self.size.y + ( -t.global_position.y / SCALE_FACTOR ),
				2.0, self.size.y - 2 
			)
			entranes_left.append( offset )
		
		elif t.location == Level_Trensition.SIDE.RIGHT:
			var offset : float = clampf(
				self.size.y + ( -t.global_position.y / SCALE_FACTOR ),
				2.0, self.size.y - 2 
			)
			entranes_right.append( offset )
		
		elif t.location == Level_Trensition.SIDE.TOP:
			var offset : float = clampf(
				t.global_position.x / SCALE_FACTOR,
				2.0, self.size.x - 2 
			)
			entranes_top.append( offset )
		
		elif t.location == Level_Trensition.SIDE.BOTTOM:
			var offset : float = clampf(
				t.global_position.x / SCALE_FACTOR,
				2.0, self.size.x - 2 
			)
			entranes_bottom.append( offset )
	


func create_entrance_blocks() ->void:
	if not transtion_blocks:
		transtion_blocks = %transtion_blocks
	for c in transtion_blocks.get_children():
		c.queue_free()
	
	for t in entranes_left:
		var block : ColorRect = add_block()
		block.size.y = 3.0
		block.position.x = 0.0
		block.position.y = t
	
	for t in entranes_right:
		var block : ColorRect = add_block()
		block.size.y = 3.0
		block.position.x = self.size.x - 1
		block.position.y = t
	
	for t in entranes_top:
		var block : ColorRect = add_block()
		block.size.x = 3.0
		block.position.y = 0.0
		block.position.x = t
	
	for t in entranes_bottom:
		var block : ColorRect = add_block()
		block.size.x = 3.0
		block.position.y = self.size.y - 1
		block.position.x = t


func add_block() -> ColorRect:
	var block : ColorRect = ColorRect.new()
	transtion_blocks.add_child( block )
	block.custom_minimum_size.x = 1.0
	block.custom_minimum_size.y = 1.0
	return block


func disblay_player_location() -> void:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	var i : Control = %player_indecator
	var pos : Vector2 = position
	pos += ( ( player.global_position - indicator_offset ) / SCALE_FACTOR )
	var clamp : Vector2 = Vector2( 3, 3 )
	pos = pos.clamp( position + clamp, position + size - clamp )
	i.position = pos

#
