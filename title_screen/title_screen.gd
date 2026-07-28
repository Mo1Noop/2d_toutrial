class_name Titel_screen extends CanvasLayer

#region /// on ready var
@onready var main_menu: VBoxContainer = %main_menu
@onready var new_game_menu: VBoxContainer = %new_game_menu
@onready var load_game_menu: VBoxContainer = %load_game_menu

@onready var new_game_button: Button = %new_game_button
@onready var load_game_button: Button = %load_game_button
@onready var exit_game_button: Button = %exit_game_button
@onready var settings_button: Button = %settings_button

@onready var new_game_menu_back: Button = %new_game_menu_back
@onready var new_slot_01: Button = %new_slot_01
@onready var new_slot_02: Button = %new_slot_02
@onready var new_slot_03: Button = %new_slot_03

@onready var load_menu_back: Button = %load_menu_back
@onready var load_slot_01: Button = %load_slot_01
@onready var load_slot_02: Button = %load_slot_02
@onready var load_slot_03: Button = %load_slot_03

@onready var settings_menu: VBoxContainer = %settings_menu
@onready var hdr_check_button: CheckButton = %HDRCheckButton
@onready var music_slider: HSlider = %Music_Slider
@onready var sfx_slider: HSlider = %SFX_Slider
@onready var ui_slider: HSlider = %UI_Slider

@onready var animation_player: AnimationPlayer = %AnimationPlayer

#endregion


func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	PlayerHud.hide()
	new_game_button.pressed.connect( show_new_game_menu )
	load_game_button.pressed.connect( show_load_game_menu )
	settings_button.pressed.connect( show_settings_menu )
	exit_game_button.pressed.connect( exit_game )
	
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
	setup_settings_menu()


func _exit_tree() -> void:
	PlayerHud.show()


func exit_game() -> void:
	Audio.fade_track_out( Audio.get_music_player( Audio.current_track ) )
	await get_tree().create_timer( 1.0 ).timeout
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			show_main_menu()


func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	settings_menu.hide()
	new_game_button.grab_focus()


func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	settings_menu.hide()
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
	settings_menu.hide()
	load_slot_01.grab_focus()
	
	load_slot_01.disabled = not SaveManager.save_file_exists( 0 )
	load_slot_02.disabled = not SaveManager.save_file_exists( 1 )
	load_slot_03.disabled = not SaveManager.save_file_exists( 2 )


func show_settings_menu() -> void:
	main_menu.hide()
	new_game_menu.hide()
	load_game_menu.hide()
	settings_menu.show()
	music_slider.grab_focus()


#region handle settings
func setup_settings_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 )
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	
	music_slider.value_changed.connect( on_music_slider_changed )
	sfx_slider.value_changed.connect( on_sfx_slider_changed )
	ui_slider.value_changed.connect( on_ui_slider_changed )
	set_hdr_button()


func on_music_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 2, val )
	SaveManager.save_settings_config()

func on_sfx_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 3, val )
	Audio.ui_focus_change()
	SaveManager.save_settings_config()

func on_ui_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 4, val )
	print(AudioServer.get_bus_volume_db( 4 ))
	Audio.ui_focus_change()
	SaveManager.save_settings_config()


func set_hdr_button() -> void:
	hdr_check_button.toggled.connect( on_hdr_toggled )
	hdr_check_button.set_pressed_no_signal( get_viewport().use_hdr_2d )
	hdr_check_button.text = "Enabeld" if get_viewport().use_hdr_2d else "Disabeld"


func on_hdr_toggled( toggled : bool ) -> void:
	get_viewport().use_hdr_2d = toggled
	hdr_check_button.text = "Enabeld" if toggled else "Disabeld"
	SaveManager.save_settings_config()
#endregion


func on_new_game_pressed( slot : int ) -> void:
	SaveManager.create_new_game_save( slot )
	SceneManger.transtion_scene(
		"uid://cb886t8m51hde", "", Vector2.ZERO, "up" )


func on_load_game_pressed( slot : int ) -> void:
	SaveManager.load_game( slot )


func _on_anim_finished( _anim_name : String ) -> void:
	animation_player.play("loop")
