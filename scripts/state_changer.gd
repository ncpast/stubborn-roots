extends Control

func _ready() -> void:
	for child in get_children():
		if child is Button and child.has_meta("tool"):
			var player_state = child.get_meta("tool")
			child.pressed.connect(_change_player_status.bind(player_state))
	
func _change_player_status(new_status: String) -> void:
	PlayerState.tool = new_status
	if PlayerState.tool == new_status:
		print(new_status)
