extends Button

signal action_requested(item_name: String)

@onready var name_label = $VBoxContainer/Name
@onready var count_label = $VBoxContainer/Count

var my_item_name: String = "" 

func _ready() -> void:
	if not is_connected("pressed", _on_pressed):
		pressed.connect(_on_pressed)
		
	PlayerState.inventory_updated.connect(_on_inventory_updated)

func setup_seed_info(plant_name: String) -> void:
	my_item_name = plant_name
	
	var plant_amount: int = PlayerState.crop_inventory[plant_name]
	
	name_label.text = plant_name 
	
	count_label.text = str(plant_amount) 
	
	print("3")

func _on_pressed() -> void:
	print("a")
	if my_item_name != "":
		Shop.sell_item(my_item_name) 
		
		action_requested.emit(my_item_name)
		
func _on_inventory_updated(changed_item_name: String, new_amount: int) -> void:
	print("2. BUTTON (", my_item_name, ") heard signal for: ", changed_item_name)
	# First, check if the item that changed is THIS button's item
	if changed_item_name == my_item_name:
		
		# If we have 0 left, destroy this button!
		if new_amount <= 0:
			queue_free() 
		else:
			# Otherwise, just update the label
			count_label.text = str(new_amount)
