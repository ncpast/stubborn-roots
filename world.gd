extends Node2D

@onready var money_label = $CanvasLayer/PanelContainer/HBoxContainer/Label
@onready var api_client = $APIClient

func _ready() -> void:
	api_client.connect_to_server()

	update_money_display()

func update_money_display() -> void:
	var current_money = api_client.get_money()

	money_label.text = str(current_money)
