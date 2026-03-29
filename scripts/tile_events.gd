extends Node2D

var highlight_layer: TileMapLayer
var last_hover_pos = Vector2i.ZERO

func _ready() -> void:
	PlayerState.tool_space_changed.connect(_on_tool_space_changed)
	PlayerState.tool_changed.connect(_on_tool_changed)
	_update_highlight()

func _update_highlight() -> void:
	if PlayerState.tool == "build":
		_create_highlight()
	else:
		_delete_highlight()

func _create_highlight() -> void:
	if highlight_layer:
		highlight_layer.queue_free()
	var tilemap = get_node(PlayerState.tool_space)
	highlight_layer = tilemap.duplicate()
	highlight_layer.clear()
	highlight_layer.modulate.a = 0.5
	highlight_layer.global_position = tilemap.global_position
	add_child(highlight_layer)

func _delete_highlight() -> void:
	if highlight_layer:
		highlight_layer.clear()
		highlight_layer.queue_free()
		highlight_layer = null

func _on_tool_space_changed() -> void:
	_update_highlight()

func _on_tool_changed() -> void:
	_update_highlight()

func _process(_delta: float) -> void:
	if highlight_layer and PlayerState.tool == "build":
		var world_pos = get_global_mouse_position()
		var tile_pos = highlight_layer.local_to_map(world_pos)
		if tile_pos != last_hover_pos:
			highlight_layer.erase_cell(last_hover_pos)
			highlight_layer.set_cell(tile_pos, 0, Vector2i(0, 0))
			last_hover_pos = tile_pos

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var tilemap = get_node(PlayerState.tool_space)
			var world_pos = get_global_mouse_position()
			var tile_pos = tilemap.local_to_map(world_pos)
			print("Tile: ", tile_pos, "; Mode: ", PlayerState.tool, "; Space: ", tilemap.name)
			if PlayerState.tool == "build":
				if tilemap.get_cell_source_id(tile_pos) == -1:
					tilemap.set_cell(tile_pos, 0, Vector2i(0, 0))
			elif PlayerState.tool == "axe":
				tilemap.erase_cell(tile_pos)
