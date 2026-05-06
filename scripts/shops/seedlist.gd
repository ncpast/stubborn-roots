extends VBoxContainer

@export var list_item: PackedScene

func _ready() -> void:
	spawn_buttons()
	
func spawn_buttons() -> void:
	for plant_id in WorldData.plants:
		var new_item = list_item.instantiate()
		add_child(new_item)
		new_item.setup_seed_info(plant_id)
