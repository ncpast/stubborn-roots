extends Button

@onready var click = $"../../../Sounds/Click"
@onready var fade_overlay = $"../../FadeOverlay"
@onready var season_icon = $"../Season/SeasonIcon"

func _ready() -> void:
	season_icon.texture = WorldData.get_current_season_icon()
	
func _pressed() -> void:
	click.play()
	var cost = WorldData.season_skip_base_cost
	if PlayerState.money < cost:
		print("Not enough money")
		return
	_change_season()

func _change_season() -> void:
	PlayerState.money -= WorldData.season_skip_base_cost
	WorldData.season_skip_base_cost *= WorldData.seasonal_price_multiplier
	WorldData.purchase_multiplier *= WorldData.seasonal_multiplier
	WorldData.cost_multiplier *= WorldData.seasonal_multiplier

	var tween = create_tween()
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	tween.tween_callback(func():
		WorldData.advance_season()
		season_icon.texture = WorldData.get_current_season_icon()
		var terrain = get_node("/root/World/terrain")  # adjust path
		WorldData.apply_season_visuals(terrain)
		get_node("/root/World/SeasonParticles").apply_season()
	)
	tween.tween_interval(0.3)
	tween.tween_property(fade_overlay, "color:a", 0.0, 0.5)
	tween.tween_callback(func():
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	)
