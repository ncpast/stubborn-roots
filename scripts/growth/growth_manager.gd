extends Node

const STAGES = [
	Vector2i(0, 0),  # seeds
	Vector2i(1, 0),  # sprout
	Vector2i(2, 0),  # mid
	Vector2i(3, 0),  # full grown
]

func _process(delta: float) -> void:
	for tile_pos in PlayerState.planted_tiles:
		var data = PlayerState.planted_tiles[tile_pos]
		var tilemap = data["tilemap"]
		if data["stage"] >= STAGES.size() - 1:
			continue
		data["time"] += delta
		if data["time"] >= data["growth_time"]:
			data["time"] = 0.0
			data["stage"] += 1
			tilemap.set_cell(tile_pos, 0, STAGES[data["stage"]])
