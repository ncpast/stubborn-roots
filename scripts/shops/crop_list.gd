extends HBoxContainer

@export var list_item: PackedScene

func _ready() -> void:
	spawn_buttons()
	print("2")
	
func spawn_buttons() -> void:
	for plant_id in PlayerState.crop_inventory:
		var new_item = list_item.instantiate()
		add_child(new_item)
		new_item.setup_seed_info(plant_id)
	
