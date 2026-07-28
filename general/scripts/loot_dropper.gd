@icon( "res://general/icons/loot_drop.svg" )
class_name Loot_Dropper extends Marker2D

@export var items : Array[ Loot_Data ]
@export var test : bool = false

func _ready() -> void:
	if test:
		var d = get_parent().find_child("Damege_area")
		if d: d.damge_taken.connect(loot_test)
	if owner is Enemy:
		owner.was_killed.connect( drop_loot )
	elif owner is Breakable:
		owner.destroyed.connect( drop_loot )

func drop_loot() -> void:
	for i in items:
		if i.drop_chance <= randf(): continue
		var drop_scene = load( i.item )
		var count : int = randi_range( i.minimum, i.maximum )
		for j in count:
			var drop = drop_scene.instantiate()
			owner.add_sibling.call_deferred( drop )
			drop.global_position = global_position
			if drop is CharacterBody2D:
				drop.velocity = Vector2(
					randf_range( -100.0, 100.0 ),
					randf_range( -200.0, -400.0 ) )

func loot_test( _a: Attack_Area ) -> void:
	for i in items:
		if i.drop_chance <= randf(): continue
		var drop_scene = load( i.item )
		var count : int = randi_range( i.minimum, i.maximum )
		for j in count:
			var drop = drop_scene.instantiate()
			owner.add_sibling.call_deferred( drop )
			drop.global_position = global_position
			if drop is CharacterBody2D:
				drop.velocity = Vector2(
					randf_range( -100.0, 100.0 ),
					randf_range( -200.0, -400.0 ) )
