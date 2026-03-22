extends Node2D

const PATH = "res://player_data/player_states.json"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Button:
			if child.has_meta("currently_equipped"):
				var player_state = child.get_meta("currently_equipped")
				child.pressed.connect(_change_player_status.bind(player_state))
			else:
				pass
	
func _change_player_status(new_status: String) -> void:
	print (new_status)
	_update_status_file(new_status)
	
func _update_status_file(new_status: String) -> void:
	var data: Dictionary = {}
	
	if FileAccess.file_exists(PATH):
		var file = FileAccess.open(PATH, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		
		if parse_result == OK and typeof(json.data) == TYPE_DICTIONARY:
			data = json.data
		file.close()
		
	data["currently_equipped"] = new_status
	
	var save_file = FileAccess.open(PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(data, "\t")
	
	save_file.store_string(json_string)
	save_file.close()
