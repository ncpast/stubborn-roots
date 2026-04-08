extends Button

@onready var name_label = $VBoxContainer/Name
@onready var price_label = $VBoxContainer/Price
@onready var desc_label = $VBoxContainer/Description

func setup_seed_info(seed_info: Dictionary) -> void:
	name_label.text = seed_info["name"]
	desc_label.text = seed_info["description"]
	price_label.text = str(seed_info["price"]["buy"])
