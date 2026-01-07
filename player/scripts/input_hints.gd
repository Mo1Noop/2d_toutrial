@icon("res://general/icons/input_hints.svg")
extends Node2D

const HINT_MAP : Dictionary = {
	"keybord" : {
		"interact" : 12,
		"attack" : 10,
		"jump" : 9,
		"dash" : 11,
		"up" : 13
	},
	"playstation" : {
		"interact" : 0,
		"attack" : 2,
		"jump" : 1,
		"dash" : 3,
		"up" : 4
	},
	"xbox" : {
		"interact" : 8,
		"attack" : 7,
		"jump" : 5,
		"dash" : 6,
		"up" : 4
	},
	"nintendo" : {
		"interact" : 7,
		"attack" : 8,
		"jump" : 6,
		"dash" : 5,
		"up" : 4
	},
}

var controller_type : String = "keybord"

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect( _on_hint_changed )


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keybord"
	elif event is InputEventJoypadButton:
		get_controller_type( event.device )


func get_controller_type( device_id : int ) -> void:
	var n : String = Input.get_joy_name(device_id).to_lower()
	
	if "xbox" in n:
		controller_type = "xbox"
	elif "nintendo" in n or "switsh" in n:
		controller_type = "nintendo"
	else:
		controller_type = "playstation"
	
	set_process_input( false )


func _on_hint_changed( hint : String ) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[ controller_type ].get( hint, "0" )
	
