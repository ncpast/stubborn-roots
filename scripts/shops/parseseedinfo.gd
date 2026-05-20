extends Button

signal buy_requested(item_name: String)

@onready var name_label = $VBoxContainer/Name
@onready var price_label = $VBoxContainer/Price
@onready var desc_label = $VBoxContainer/Description
@onready var icon_rect = $TextureRect

var my_item_name: String = "" 

func _ready() -> void:
	# Connect the signal here so it always works
	if not is_connected("pressed", _on_pressed):
		pressed.connect(_on_pressed)

func setup_seed_info(plant_name: String) -> void:
	if not is_node_ready():
		await ready
	
	my_item_name = plant_name
	var plant_data = WorldData.plants[plant_name]
	
	name_label.text = plant_data.get("name", plant_name) 
	desc_label.text = plant_data["description"]
	
	var final_cost = plant_data["purchase"]["cost"] * WorldData.purchase_multiplier 
	price_label.text = str(final_cost)
	
	var icon_path = "res://assets/icons/" + plant_name + ".png"
	if ResourceLoader.exists(icon_path):
		icon_rect.texture = load(icon_path)
	else:
		push_warning("Icon not found for: " + plant_name + " at " + icon_path)

func _on_pressed() -> void:
	print ("a")
	if my_item_name != "":
		# This calls the buy logic we wrote earlier
		Shop.buy_item(my_item_name)
		
		# Optional: still emit the signal if other parts of the UI 
		# (like an inventory counter) need to know a purchase happened
		buy_requested.emit(my_item_name)
