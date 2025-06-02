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
				data["Source Node"].hide()
		
		# This is for the cookie
		if data["Name"] == "Cookie":
			var cookie_value = data["Value"]
			get_parent().get_parent()._feed(cookie_value)
			
			# Hiding the cookie after it's been eaten
			if data.has("Source Node"):
				data["Source Node"].hide()
		
		# This is for the lettuce
		if data["Name"] == "Lettuce":
			var lettuce_value = data["Value"]
			get_parent().get_parent()._feed(lettuce_value)
			
			# Hiding the lettuce after it's been eaten
			if data.has("Source Node"):
				data["Source Node"].hide()
		
		# BATHROOM ITEMS ######################################################
		if data["Name"] == "Toilet Paper":
			var toilet_value = data["Value"]
			get_parent().get_parent()._go_bathroom(toilet_value)
			
			# Hiding the toilet paper after it's been used
			if data.has("Source Node"):
				data["Source Node"].hide()
		
		# SHOWER ITEMS ########################################################
		if data["Name"] == "Shower Sponge":
			var shower_value = data["Value"]
			get_parent().get_parent()._go_shower(shower_value)
			
			# Hiding the sponge after it's been used
			if data.has("Source Node"):
				data["Source Node"].hide()
