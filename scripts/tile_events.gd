extends Node2D

@onready var work = $terrain/Sounds/Dirt_work
@onready var plant = $terrain/Sounds/Plant
@onready var gather = $terrain/Sounds/Gather

var highlight_layer: TileMapLayer
var last_hover_pos = Vector2i.ZERO

func _ready() -> void:
	PlayerState.tool_space_changed.connect(_on_tool_space_changed)
	PlayerState.tool_changed.connect(_on_tool_changed)
	_update_highlight()

func _update_highlight() -> void:
	if PlayerState.tool == "build" || PlayerState.tool == "plant":
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
	if highlight_layer and (PlayerState.tool == "plant" || PlayerState.tool == "build"):
		var world_pos = get_global_mouse_position()
		var tile_pos = highlight_layer.local_to_map(world_pos)
		if tile_pos != last_hover_pos:
			highlight_layer.erase_cell(last_hover_pos)
			highlight_layer.set_cell(tile_pos, PlayerState.selected_source_id, PlayerState.selected_tile)
			last_hover_pos = tile_pos

func _add_to_inventory(item: String, amount: int) -> void:
	if PlayerState.crop_inventory.has(item):
		PlayerState.crop_inventory[item] += amount
	else:
		PlayerState.crop_inventory[item] = amount
	print("Inventory: ", PlayerState.crop_inventory)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var tilemap: TileMapLayer = get_node(PlayerState.tool_space)
			var world_pos = get_global_mouse_position()
			var tile_pos = tilemap.local_to_map(world_pos)
			
			var terrain_map: TileMapLayer = get_node(PlayerState.terrain_map)
			var terrain_source_id = terrain_map.get_cell_source_id(tile_pos)
			var terrain_atlas = terrain_map.get_cell_atlas_coords(tile_pos)
			var can_be_planted: bool = terrain_source_id == 1 && terrain_atlas == Vector2i(0, 1)
			
			var plant_data = WorldData.plants[PlayerState.selected_crop]
			var cost = plant_data.purchase.cost * WorldData.purchase_multiplier
			
			#print("Tile: ", tile_pos, "; Mode: ", PlayerState.tool, "; Space: ", tilemap.name)
			
			if PlayerState.tool == "plant" && can_be_planted:
				match tilemap.get_cell_source_id(tile_pos):
					-1:
						if PlayerState.money >= cost:
							PlayerState.money -= cost
							tilemap.set_cell(tile_pos, plant_data.tile_origin_id, PlayerState.selected_tile)
							PlayerState.planted_tiles[tile_pos] = { "stage": 0, "time": 0.0, 
							"tilemap": tilemap, "growth_time": 2, "tile_origin_id": plant_data.tile_origin_id,
							"name": PlayerState.selected_crop }
							plant.play()
			elif PlayerState.tool == "axe":
				tilemap.erase_cell(tile_pos)
			elif PlayerState.tool == "gather":
				var source_id = tilemap.get_cell_source_id(tile_pos)
				var atlas_coord = tilemap.get_cell_atlas_coords(tile_pos)
				if source_id != -1 and atlas_coord == Vector2i(3, 0):
					tilemap.erase_cell(tile_pos)
					gather.play()
					var gathered_name = PlayerState.planted_tiles[tile_pos].name
					PlayerState.planted_tiles.erase(tile_pos)
					_add_to_inventory(gathered_name, 1)
					terrain_map.set_cell(tile_pos, 1, Vector2i(0, 3)) # replace with dirt
			elif PlayerState.tool == "shovel":
				if terrain_source_id == 1 && terrain_atlas == Vector2i(0, 3):
					terrain_map.set_cell(tile_pos, 1, Vector2i(0, 1))
					work.play()
