extends Control

# Thhis is to create a drop target over the pet so the
# Food items can be dragged and dropped 
func can_drop_data(position, data):
	var can_drop = data.has("Value")
	print("Can drop data?: ", can_drop)
	return can_drop

# This is to actually have the pet react to the item
# That is getting dropped
func drop_data(position, data):
	print("Dropped on Drag and Drop Zone: ", data)
	var food_value = data.get("Value, 0")
	get_parent()._feed(food_value)
