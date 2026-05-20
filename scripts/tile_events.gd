extends Node2D

@onready var work = $terrain/Sounds/Dirt_work
@onready var plant = $terrain/Sounds/Plant
@onready var gather = $terrain/Sounds/Gather
@onready var hammer = $terrain/Sounds/Hammer
@onready var craft = $terrain/Sounds/Craft
@onready var craft2 = $terrain/Sounds/Craft2

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
	if highlight_layer and (PlayerState.tool == "plant"):
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
			var buildingmap: TileMapLayer = get_node("terrain/props_large")
			var world_pos = get_global_mouse_position()
			var tile_pos = tilemap.local_to_map(world_pos)
			
			var building_pos = buildingmap.local_to_map(world_pos)
			var source_id_buildings = buildingmap.get_cell_source_id(building_pos)
			var atlas_coord_buildings = buildingmap.get_cell_atlas_coords(building_pos)
			
			var is_windmill: bool = source_id_buildings == 67
			
			var terrain_map: TileMapLayer = get_node(PlayerState.terrain_map)
			var terrain_source_id = terrain_map.get_cell_source_id(tile_pos)
			var terrain_atlas = terrain_map.get_cell_atlas_coords(tile_pos)
			var can_be_planted: bool = terrain_source_id == 1 && terrain_atlas == Vector2i(0, 1)
			
			var plant_data = WorldData.plants[PlayerState.selected_crop]
			var cost = plant_data.purchase.cost * WorldData.purchase_multiplier
			
			if PlayerState.tool == "plant" && can_be_planted && !is_windmill:
				match tilemap.get_cell_source_id(tile_pos):
					-1:
						if PlayerState.money >= cost:
							PlayerState.money -= cost
							tilemap.set_cell(tile_pos, plant_data.tile_origin_id, PlayerState.selected_tile)
							PlayerState.planted_tiles[tile_pos] = { "stage": 0, "time": 0.0, 
							"tilemap": tilemap, "growth_time": 2, "tile_origin_id": plant_data.tile_origin_id,
							"name": PlayerState.selected_crop }
							plant.play()
							
							spawn_pure_text("-" + str(cost) + "$", Color.RED, tilemap, tile_pos)
							spawn_pure_particles(tilemap, tile_pos, Color(0.34, 0.275, 0.218, 1.0))
							
			elif PlayerState.tool == "axe":
				tilemap.erase_cell(tile_pos)
				buildingmap.erase_cell(building_pos)
			elif PlayerState.tool == "gather":
				var source_id = tilemap.get_cell_source_id(tile_pos)
				var atlas_coord = tilemap.get_cell_atlas_coords(tile_pos)
				
				if source_id_buildings == 67 and PlayerState.crop_inventory.get("wheat", 0) >= 5:
					PlayerState.crop_inventory["wheat"] -= 5
					
					craft.play()
					craft2.play()
					if PlayerState.crop_inventory.has("bread"):
						PlayerState.crop_inventory["bread"] += 1
					else:
						PlayerState.crop_inventory["bread"] = 1
					print(PlayerState.crop_inventory)
					
					spawn_pure_text("-5 Wheat", Color.RED, buildingmap, building_pos)
					spawn_pure_particles(buildingmap, building_pos, Color(0.34, 0.275, 0.218, 1.0))
					
					await get_tree().create_timer(0.3).timeout
					
					spawn_pure_text("+1 Bread", Color.GREEN, buildingmap, building_pos)
					spawn_pure_particles(buildingmap, building_pos, Color(0.9, 0.8, 0.6, 1.0))
				
				if source_id != -1 and atlas_coord == Vector2i(3, 0):
					tilemap.erase_cell(tile_pos)
					gather.play()
					var gathered_name = PlayerState.planted_tiles[tile_pos].name
					PlayerState.planted_tiles.erase(tile_pos)
					_add_to_inventory(gathered_name, 1)
					terrain_map.set_cell(tile_pos, 1, Vector2i(0, 3))
					
					spawn_pure_text("+1 " + gathered_name.capitalize(), Color.GREEN, tilemap, tile_pos)
					spawn_pure_particles(terrain_map, tile_pos, Color(0.34, 0.275, 0.218, 1.0))
					
			elif PlayerState.tool == "shovel" && !is_windmill:
				if terrain_source_id == 1 && terrain_atlas == Vector2i(0, 3):
					terrain_map.set_cell(tile_pos, 1, Vector2i(0, 1))
					work.play()
					
					spawn_pure_particles(terrain_map, tile_pos, Color(0.34, 0.275, 0.218, 1.0))
			elif PlayerState.tool == "build" && !is_windmill:
				if PlayerState.money >= WorldData.buildings.windmill.cost:
					PlayerState.money -= WorldData.buildings.windmill.cost
					buildingmap.set_cell(building_pos, 67, Vector2i(0, 0))
					hammer.play()
					spawn_pure_text("-" + str(WorldData.buildings.windmill.cost) + "$", Color.RED, buildingmap, building_pos)
					spawn_pure_particles(buildingmap, building_pos, Color(0.34, 0.275, 0.218, 1.0))

func spawn_pure_text(txt: String, custom_color: Color, target_layer: TileMapLayer, tile_pos: Vector2i):
	var label = Label.new()
	label.text = txt
	label.modulate = custom_color
	label.z_index = 10
	label.scale = Vector2(0.75, 0.75)
	label.global_position = target_layer.map_to_local(tile_pos) + Vector2(randf_range(-15, 15), 0)
	get_tree().current_scene.add_child(label)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 60, 1.0)
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	tween.chain().tween_callback(label.queue_free)

func spawn_pure_particles(target_layer: TileMapLayer, tile_pos: Vector2i, particle_color: Color):
	var particles = CPUParticles2D.new()
	particles.position = target_layer.map_to_local(tile_pos)
	particles.amount = 100
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.direction = Vector2(0, -1)
	particles.spread = 45.0
	particles.gravity = Vector2(0, 250)
	particles.initial_velocity_min = 60.0
	particles.initial_velocity_max = 100.0
	particles.color = particle_color
	
	get_tree().current_scene.add_child(particles)
	particles.emitting = true
	
	var timer = get_tree().create_timer(particles.lifetime)
	timer.timeout.connect(particles.queue_free)
