extends CanvasLayer # player hud

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HP_BAR
@onready var game_over: Control = %game_over
@onready var load_button: Button = %Load_Button
@onready var quit_button: Button = %Quit_Button


func _ready() -> void:
	Messages.player_helth_changed.connect( update_helth_bar )
	game_over.visible = false
	load_button.pressed.connect( _on_load_button_pressed )
	quit_button.pressed.connect( _on_quit_button_pressed )


func update_helth_bar( hp : float, max_hp : float ) -> void:
	var value : float = (hp / max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22


func show_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	
	game_over.modulate.a = 0.0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property( game_over, "modulate", Color.WHITE, 1.0 )
	await tween.finished
	
	load_button.visible = true
	quit_button.visible = true
	load_button.grab_focus()


func clear_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	await SceneManger.scene_entered
	game_over.visible = false
	get_tree().get_first_node_in_group("Player").queue_free()


func _on_load_button_pressed() -> void:
	clear_game_over()
	SaveManager.load_game( SaveManager.current_slot )


func _on_quit_button_pressed() -> void:
	clear_game_over()
	SceneManger.transtion_scene(
		"res://title_screen/BG_menu.tscn", "", Vector2.ZERO, "up" )
