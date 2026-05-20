extends Node

var purchase_multiplier = 1
var cost_multiplier = 1

var seasonal_multiplier = 1.5
var seasonal_price_multiplier = 2
var season_skip_base_cost = 1000

var current_season = 0
var seasonal_sequence = [
	"res://assets/icons/summer.png",
	"res://assets/icons/autumn.png",
	"res://assets/icons/winter.png",
	"res://assets/icons/spring.png",
]

func get_current_season_icon() -> Texture2D:
	return load(seasonal_sequence[current_season % seasonal_sequence.size()])

func advance_season() -> void:
	current_season = (current_season + 1) % 4

var season_tile_column = [0, 4, 5, 6]  # summer, autumn, winter, spring columns
func apply_season_visuals(terrain: TileMapLayer) -> void:
	for tile_pos in terrain.get_used_cells():
		var atlas = terrain.get_cell_atlas_coords(tile_pos)
		if atlas.y == season_tile_column[(current_season - 1) % 4]:
			terrain.set_cell(tile_pos, 1, Vector2i(atlas.x, season_tile_column[current_season]))
	var trees = get_node("/root/World/terrain/props")
	for tile_pos in trees.get_used_cells():
		var atlas = trees.get_cell_atlas_coords(tile_pos)
		if trees.get_cell_source_id(tile_pos) == 0:
			trees.set_cell(tile_pos, 0, Vector2i(current_season, 0))

var buildings = {
	"windmill": {
		"cost": 1000
	}
}

var plants = {
	"wheat": {
		"purchase": {
			"cost": 5
		},
		"tile_origin_id": 0,
		"sell": {
			"cost": 7
		},
		"growth_time": 100,
		"description": "Wheat grows on soil"
	},
	"carrot": {
		"purchase": {
			"cost": 10
		},
		"tile_origin_id": 2,
		"sell": {
			"cost": 16
		},
		"growth_time": 200,
		"description": "Carrots grow on soil"
	},
	"tomato": {
		"name": "Tomato",
		"purchase": {
			"cost": 15
		},
		"tile_origin_id": 1,
		"sell": {
			"cost": 25
		},
		"growth_time": 130,
		"description": "Tomatoes grow on soil"
	},
	"bread": {
		"name": "Bread",
		"plantable": false,
		"sell": {
			"cost": 50
		},
		"description": "Make bread out of wheat to sell at a higher price"
	}
}
