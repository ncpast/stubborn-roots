extends Node

var file_path = "res://player_data/player_data.json"
var last_money_value: int = -1

# Signal to tell other scripts (like your UI) to update
signal money_updated(new_amount)

func _ready():
	var timer = Timer.new()
	timer.wait_time = 1.0 
	timer.autostart = true
	add_child(timer)
	
	timer.timeout.connect(_check_for_updates)
	
	_check_for_updates()

func _check_for_updates():
	var current_money = get_money()
	
	if current_money != last_money_value:
		last_money_value = current_money
		money_updated.emit(current_money)
		print("File changed! New money: ", current_money)

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
