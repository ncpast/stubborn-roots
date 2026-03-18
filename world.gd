extends Node2D

@onready var money_label = $HUD/PanelContainer/HBoxContainer/MoneyLabel
@onready var api = $APIClient

func _ready() -> void:
	api.money_updated.connect(_on_money_updated)
	
	var amount = api.get_money()
	money_label.text = str(amount)
	print("UI Initialized with balance: ", amount)

func _on_money_updated(new_amount: int) -> void:
	money_label.text = str(new_amount)
	print("UI Auto-Updated to: ", new_amount)
