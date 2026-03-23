extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var tilemap = get_node(PlayerState.tool_space)
			var world_pos = get_global_mouse_position()
			var tile_pos = tilemap.local_to_map(world_pos)
			print("Tile: ", tile_pos, "; Mode: ", PlayerState.tool, "; Space: ", tilemap.name)
