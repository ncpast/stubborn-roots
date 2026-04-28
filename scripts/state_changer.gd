extends Control

func _ready() -> void:
	for child in get_children():
		if child is Button and child.has_meta("tool"):
			var player_state = child.get_meta("tool")
			child.pressed.connect(_change_player_status.bind(player_state))

func _change_player_status(new_status: String) -> void:
	PlayerState.update_tool(new_status)
	
	for child in get_children():
		if child is Button and child.has_meta("tool"):
			if child.get_meta("tool") == new_status:
				_set_button_border(child, Color(1.0, 1.0, 1.0, 0.4))
			else:
				_clear_button_border(child)

func _set_button_border(button: Button, color: Color) -> void:
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style = StyleBoxFlat.new()
		style.border_color = color
		style.set_border_width_all(2)
		var existing = button.get_theme_stylebox(state)
		if existing is StyleBoxFlat:
			style.bg_color = existing.bg_color
			style.corner_radius_top_left = existing.corner_radius_top_left
			style.corner_radius_top_right = existing.corner_radius_top_right
			style.corner_radius_bottom_left = existing.corner_radius_bottom_left
			style.corner_radius_bottom_right = existing.corner_radius_bottom_right
		else:
			style.bg_color = Color(0.15, 0.15, 0.15, 1)
		button.add_theme_stylebox_override(state, style)

func _clear_button_border(button: Button) -> void:
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		button.remove_theme_stylebox_override(state)
