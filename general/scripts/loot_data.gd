class_name Loot_Data extends Resource

@export_file( "*.tscn" ) var item : String
@export var minimum : int = 1 ## the minimum number of item's dropped
@export var maximum : int = 1 ## the maximum number of item's dropped
@export var drop_chance : float = 0.5
