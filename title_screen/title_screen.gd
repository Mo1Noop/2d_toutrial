class_name Titel_screen extends CanvasLayer

#region /// on ready var
@onready var main_menu: VBoxContainer = %main_menu
@onready var new_game_menu: VBoxContainer = %new_game_menu
@onready var load_game_menu: VBoxContainer = %load_game_menu

@onready var new_game_button: Button = %new_game_button
@onready var load_game_button: Button = %load_game_button

@onready var new_slot_01: Button = %new_slot_01
@onready var new_slot_02: Button = %new_slot_02
@onready var new_slot_03: Button = %new_slot_03
@onready var new_game_menu_back: Button = %new_game_menu_back

@onready var load_slot_01: Button = %load_slot_01
@onready var load_slot_02: Button = %load_slot_02
@onready var load_slot_03: Button = %load_slot_03
@onready var load_menu_back: Button = %load_menu_back

@onready var animation_player: AnimationPlayer = %AnimationPlayer

#endregion


func _ready() -> void:
	PlayerHud.visible = false
	new_game_button.pressed.connect( show_new_game_menu )
	load_game_button.pressed.connect( show_load_game_menu )
	
	new_slot_01.pressed.connect( on_new_game_pressed.bind( 0 ) )
	new_slot_02.pressed.connect( on_new_game_pressed.bind( 1 ) )
	new_slot_03.pressed.connect( on_new_game_pressed.bind( 2 ) )
	
	load_slot_01.pressed.connect( on_load_game_pressed.bind( 0 ) )
	load_slot_02.pressed.connect( on_load_game_pressed.bind( 1 ) )
	load_slot_03.pressed.connect( on_load_game_pressed.bind( 2 ) )
	
	load_menu_back.pressed.connect( show_main_menu )
	new_game_menu_back.pressed.connect( show_main_menu )
	
	Audio.setup_button_audio( self )
	
	animation_player.animation_finished.connect( _on_anim_finished )
	show_main_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			show_main_menu()


func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	new_game_button.grab_focus()


func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	new_slot_01.grab_focus()
	
	if SaveManager.save_file_exists( 0 ):
		new_slot_01.text = "Replace slot 01"
	
	if SaveManager.save_file_exists( 1 ):
		new_slot_02.text = "Replace slot 02"
	
	if SaveManager.save_file_exists( 2 ):
		new_slot_03.text = "Replace slot 03"


func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	load_slot_01.grab_focus()
	
	load_slot_01.disabled = not SaveManager.save_file_exists( 0 )
	load_slot_02.disabled = not SaveManager.save_file_exists( 1 )
	load_slot_03.disabled = not SaveManager.save_file_exists( 2 )


func on_new_game_pressed( slot : int ) -> void:
	SaveManager.create_new_game_save( slot )
	SceneManger.transtion_scene(
		"uid://cb886t8m51hde", "", Vector2.ZERO, "up"
	)


func on_load_game_pressed( slot : int ) -> void:
	SaveManager.load_game( slot )


func _on_anim_finished( _anim_name : String ) -> void:
	animation_player.play("loop")



#
