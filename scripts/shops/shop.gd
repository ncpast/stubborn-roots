extends Node

func buy_item(item_name: String):
	var plant_data = WorldData.plants[item_name]
	var cost = plant_data["purchase"]["cost"] * WorldData.purchase_multiplier
	PlayerState.selected_crop = item_name
	print("selected crop: ", PlayerState.selected_crop)

func sell_item(item_name: String):
	# Get the total amount the player currently has (defaults to 0 if not found)
	var amount_to_sell = PlayerState.crop_inventory.get(item_name, 0)
	
	# Check if we have at least 1 of the item
	if amount_to_sell > 0:
		
		# 1. Get the price data for a single item
		var plant_data = WorldData.plants[item_name]
		var single_item_price = plant_data["sell"]["cost"]
		
		# Calculate the total money earned from selling the whole stack
		var total_price = single_item_price * amount_to_sell
		
		# 2. Update the Money
		PlayerState.money += total_price
		
		# 3. Clean up the dictionary since we sold all of them
		PlayerState.crop_inventory.erase(item_name)
		
		# 4. Tell the buttons to update! (The new amount is always 0)
		print("1. EMITTING SIGNAL: ", item_name, " is now 0")
		PlayerState.inventory_updated.emit(item_name, 0)
			
		# Optional: Updated print statement to show how many were sold
		print("Sold ", amount_to_sell, " ", item_name, "(s) for ", total_price, ". Total Money: ", PlayerState.money)
		get_node("/root/World/terrain/Sounds/Sell").play()
	else:
		print("Cannot sell: No ", item_name, " in inventory.")
