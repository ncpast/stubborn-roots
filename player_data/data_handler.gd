extends Node

var file_path = "res://player_data/player_data.json"

func get_money() -> int:
	if not FileAccess.file_exists(file_path):
		print("File missing!")
		return 0

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		var data = json.get_data()
		return data.get("money", 0)
	return 0
