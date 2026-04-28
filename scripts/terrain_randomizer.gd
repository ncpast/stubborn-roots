extends TileMapLayer

const GRASS_ATLAS = Vector2i(0, 0)
const FLOWER_CHANCE = 0.1

func _ready() -> void:
	_scatter_flowers()

func _scatter_flowers() -> void:
	for tile_pos in get_used_cells():
		var atlas = get_cell_atlas_coords(tile_pos)
		if atlas == GRASS_ATLAS:
			const FLOWER_VARIANTS = [Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2(4, 0)]
			if randf() < FLOWER_CHANCE:
				var variant = FLOWER_VARIANTS[randi() % FLOWER_VARIANTS.size()]
				set_cell(tile_pos, get_cell_source_id(tile_pos), variant)
