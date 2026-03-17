extends Node2D

@onready var money_label = $HUD/PanelContainer/HBoxContainer/MoneyLabel
@onready var api = $APIClient

func _ready() -> void:
	var amount = api.get_money()
	
	money_label.text = str(amount)
	
	print("UI Updated with balance: ", amount)
