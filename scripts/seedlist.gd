extends VBoxContainer

@export var list_item: PackedScene

func _ready() -> void:
	spawn_buttons()
	
func spawn_buttons() -> void:
	for i in SeedInfo.seedinfo:
		var current_seed_data = SeedInfo.seedinfo[i]
		var new_item = list_item.instantiate()
		add_child(new_item)
		new_item.setup_seed_info(current_seed_data)
		
