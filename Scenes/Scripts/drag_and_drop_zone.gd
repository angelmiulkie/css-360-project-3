extends Control

# Thhis is to create a drop target over the pet so the
# Food items can be dragged and dropped 
func _can_drop_data(position, data) -> bool:
	return data.has("Name") and data["Name"] == "Strawberry"

# This is to actually have the pet react to the item
# That is getting dropped
func _drop_data(position, data) -> void:
	if _can_drop_data(position, data):
		var strawberry_value = data["Value"]
		get_parent().get_parent()._feed(strawberry_value)
