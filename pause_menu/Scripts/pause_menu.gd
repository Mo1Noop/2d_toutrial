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

#endregion

var player : Player


func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect( show_system_menu )
	setup_system_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
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
	back_title_button.pressed.connect( on_back_title_button_pressed )
	back_map_button.pressed.connect( show_pause_screen )


func on_back_title_button_pressed() -> void:
	SceneManger.transtion_scene(
		"res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()






#
