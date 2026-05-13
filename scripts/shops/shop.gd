extends Node

func buy_item(item_name: String):
	var plant_data = WorldData.plants[item_name]
	var cost = plant_data["purchase"]["cost"] * WorldData.purchase_multiplier
	PlayerState.selected_crop = item_name
	print("selected crop: ", PlayerState.selected_crop)

func sell_item(item_name: String):
	# Check if we have at least 1 of the item
	if PlayerState.crop_inventory.get(item_name, 0) > 0:
		
		# 1. Get the price data
		var plant_data = WorldData.plants[item_name]
		var price = plant_data["sell"]["cost"]
		
		# 2. Update the Inventory & Money ONCE
		PlayerState.crop_inventory[item_name] -= 1
		PlayerState.money += price
		
		var new_amount = PlayerState.crop_inventory[item_name]
		
		# 3. Clean up the dictionary if we hit 0
		if new_amount == 0:
			PlayerState.crop_inventory.erase(item_name)
			
		# 4. Tell the buttons to update!
		print("1. EMITTING SIGNAL: ", item_name, " is now ", new_amount)
		PlayerState.inventory_updated.emit(item_name, new_amount)
			
		print("Sold ", item_name, ". Money: ", PlayerState.money)
		
	else:
		print("Cannot sell: No ", item_name, " in inventory.")
