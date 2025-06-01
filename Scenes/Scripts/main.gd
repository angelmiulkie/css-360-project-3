extends Node2D

# Assinging Variables
# Assigning the inventory 
@onready var inventory_panel = get_node("Inventory Panel")
@onready var bathroom_inventory = get_node("Bathroom Inventory Panel")
@onready var shower_inventory = get_node("Shower Inventory Panel")

func _ready():
	var pet_node = $Pet

# If the Food Icon Button is pressed, then it'll make the inventory visible
# and all the other buttons invisible
func _on_food_icon_button_pressed() -> void:
	inventory_panel.visible = true
	$"Action Buttons".visible = false

# If the X button is pressed, the inventory would disappear
# and then the icons would come back 
func _on_inventory_x_button_pressed() -> void:
	inventory_panel.visible = false
	$"Action Buttons".visible = true

# If the Bathroom Icon is pressed then it'll make the bathroom inventory
# visible and all the other buttons invisible
func _on_bathroom_icon_button_pressed() -> void:
	bathroom_inventory.visible = true
	$"Action Buttons".visible = false

# If the X button is pressed, the bathroom inventory would disappear
# and then all the icons would come back 
func _on_bathroom_inventory_x_button_pressed() -> void:
	bathroom_inventory.visible = false
	$"Action Buttons".visible = true

# If the Shower Icon is pressed, then the shower inventory will
# become visible and all the other buttons invisible
func _on_washing_icon_button_pressed() -> void:
	shower_inventory.visible = true
	$"Action Buttons".visible = false

# If the x Button is pressed, the shower inventory would disappear
# and then all the icons would come back
func _on_shower_inventory_x_button_pressed() -> void:
	shower_inventory.visible = false
	$"Action Buttons".visible = true
