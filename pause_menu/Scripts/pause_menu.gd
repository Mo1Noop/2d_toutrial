class_name Pause_Menu extends CanvasLayer

#region /// On ready var
@onready var pause_screen: Control = %pause_screen
@onready var system: Control = %system
@onready var system_menu_button: Button = %system_menu_Button
@onready var back_map_button: Button = %Back_map_Button
@onready var back_title_button: Button = %Back_Title_Button
@onready var music_slider: HSlider = %Music_Slider
@onready var sfx_slider: HSlider = %SFX_Slider
@onready var ui_slider: HSlider = %UI_Slider

var player : Player

#endregion


func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect( show_system_menu )
	Audio.setup_button_audio( self )
	setup_system_menu()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		queue_free()
	if pause_screen.visible:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menu_button.grab_focus()


func show_pause_screen() -> void:
	pause_screen.visible = true
	system.visible = false


func show_system_menu() -> void:
	pause_screen.visible = false
	system.visible = true
	back_map_button.grab_focus()


func setup_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 )
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	
	music_slider.value_changed.connect( on_music_slider_changed )
	sfx_slider.value_changed.connect( on_sfx_slider_changed )
	ui_slider.value_changed.connect( on_ui_slider_changed )
	
	
	back_title_button.pressed.connect( on_back_title_button_pressed )
	back_map_button.pressed.connect( show_pause_screen )


func on_back_title_button_pressed() -> void:
	SceneManger.transtion_scene(
		"uid://cvi1svgb3cnok", "", Vector2.ZERO, "up" )
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()


func on_music_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 2, val )
	SaveManager.save_audio_config()

func on_sfx_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 3, val )
	Audio.ui_focus_change()
	SaveManager.save_audio_config()

func on_ui_slider_changed( val : float ) -> void:
	AudioServer.set_bus_volume_linear( 4, val )
	Audio.ui_focus_change()
	SaveManager.save_audio_config()
