extends Node
signal tool_space_changed
signal tool_changed

var tool = "build"
var tool_space = "terrain/props"
var selected_tile = "grass"

func update_state(new_tool_space):
	tool_space = new_tool_space
	emit_signal("tool_space_changed")

func update_tool(new_tool):
	tool = new_tool
	emit_signal("tool_changed")
