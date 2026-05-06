extends Node
signal tool_space_changed
signal tool_changed
signal inventory_updated(item_name: String, new_amount: int)

var tool = "none"
var tool_space = "terrain/crops"
var terrain_map = "terrain"

var selected_tile = Vector2i(0, 0)
var selected_source_id = 0
var planted_tiles = {}

var money = 100;
var seed_inventory = {}
var crop_inventory = {
	"Wheat" :1,
	"Tomato" :1,
	"Potato" :1,
}

func update_state(new_tool_space):
	tool_space = new_tool_space
	emit_signal("tool_space_changed")

func update_tool(new_tool):
	tool = new_tool
	emit_signal("tool_changed")
