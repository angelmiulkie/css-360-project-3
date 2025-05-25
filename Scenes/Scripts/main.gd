extends Node2D

# Assinging Variables
# Assigning the inventory 
@onready var inventory_panel = get_node("Inventory Panel")

# If the Food Icon Button is pressed, then it'll make the inventory visible
# and all the other buttons invisible
func _on_food_icon_button_pressed() -> void:
	inventory_panel.visible = !inventory_panel.visible
	$"Action Buttons".visible = !$"Inventory Panel".visible
