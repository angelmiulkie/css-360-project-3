extends Control

# Thhis is to create a drop target over the pet so the
# Food items can be dragged and dropped 
func _can_drop_data(position, data) -> bool:
	return data.has("Name")

# This is to actually have the pet react to the item
# That is getting dropped
func _drop_data(position, data) -> void:
	if _can_drop_data(position, data):
		# FOOD ITEMS ##########################################################
		# This is for the strawberry 
		if data["Name"] == "Strawberry":
			var strawberry_value = data["Value"]
			get_parent().get_parent()._feed(strawberry_value)
			
			# Hiding the strawberry after it's been eaten
			if data.has("Source Node"):
				var strawberry_source = data["Source Node"]
				strawberry_source.was_dropped = true
				strawberry_source.hide()
				print("Visibility: ", strawberry_source.visible)
		
		# This is for the cookie
		if data["Name"] == "Cookie":
			var cookie_value = data["Value"]
			get_parent().get_parent()._feed(cookie_value)
			
			# Hiding the cookie after it's been eaten
			if data.has("Source Node"):
				var cookie_source = data["Source Node"]
				cookie_source.was_dropped = true
				cookie_source.hide()
				print("Visibility: ", cookie_source.visible)
		
		# This is for the lettuce
		if data["Name"] == "Lettuce":
			var lettuce_value = data["Value"]
			get_parent().get_parent()._feed(lettuce_value)
			
			# Hiding the lettuce after it's been eaten
			if data.has("Source Node"):
				var lettuce_source = data["Source Node"]
				lettuce_source.was_dropped = true
				lettuce_source.hide()
				print("Visibility: ", lettuce_source)
		
		# BATHROOM ITEMS ######################################################
		if data["Name"] == "Toilet Paper":
			var toilet_value = data["Value"]
			get_parent().get_parent()._go_bathroom(toilet_value)
			
			# Hiding the toilet paper after it's been used
			if data.has("Source Node"):
				var toilet_source = data["Source Node"]
				toilet_source.was_dropped = true
				toilet_source.hide()
				print("Visibility: ", toilet_source )
		
		# SHOWER ITEMS ########################################################
		if data["Name"] == "Shower Sponge":
			var shower_value = data["Value"]
			get_parent().get_parent()._go_shower(shower_value)
			
			# Hiding the sponge after it's been used
			if data.has("Source Node"):
				var sponge_source = data["Source Node"]
				sponge_source.was_dropped = true
				sponge_source.hide()
				print("Visibility: ", sponge_source)
		
		
		get_parent().get_parent().get_parent()._save_inventory()
