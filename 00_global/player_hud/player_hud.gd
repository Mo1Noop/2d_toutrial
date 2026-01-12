extends CanvasLayer # player hud

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HP_BAR

func _ready() -> void:
	Messages.player_helth_changed.connect( update_helth_bar )


func update_helth_bar( hp : float, max_hp : float ) -> void:
	var value : float = (hp / max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22


func show_hud() -> void:
	await SceneManger.load_scene_finished
	visible = true
