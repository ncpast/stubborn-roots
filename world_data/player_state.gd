extends Node
signal tool_space_changed
signal tool_changed

var tool = "build"
var tool_space = "terrain/crops"

var selected_tile = Vector2i(0, 0)
var selected_source_id = 0
var planted_tiles = {}

var inventory = {}

func update_state(new_tool_space):
	tool_space = new_tool_space
	emit_signal("tool_space_changed")

func update_tool(new_tool):
	tool = new_tool
	emit_signal("tool_changed")
