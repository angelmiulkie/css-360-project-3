extends Node2D

# Assinging Variables
# Assigning the inventory 
@onready var inventory_panel = get_node("Inventory Panel")
@onready var bathroom_inventory = get_node("Bathroom Inventory Panel")
@onready var shower_inventory = get_node("Shower Inventory Panel")
@onready var shop_inventory = get_node("Shop")

# Assinging the timer for money/coins
@onready var coin_timer = $"Coin Timer"
@onready var coin_label = $"Coins/Coins Label"
const coin_save_path := "user://coins.save" # Saving the coins for each save
var coins := 50

# Assigning the shop to buy items
@onready var shop_scene = preload("res://Scenes/shop.tscn")

func _ready():
	var pet_node = $Pet
	
	# For the coin timer to start
	# And updating the coins
	_load_coins()
	_update_coin_label()
	coin_timer.timeout.connect(_on_coin_timer_timeout)
	coin_timer.start()

# COIN FUNCTIONS ###############################################################
# Updating the coins after every 5 minutes, you get 5 coins
func _on_coin_timer_timeout():
	coins += 5
	_save_coins()
	_update_coin_label()
	print("Coins earned! Total coins: ", coins)
	# TODO: emit a singal for the UI to update

# Updating the coin label if you ever spend any money
func _update_coin_label():
	coin_label.text = "%d" % coins

# Saving the coins 
func _save_coins():
	var file = FileAccess.open(coin_save_path, FileAccess.WRITE)
	file.store_var(coins)

# Then loading the coins once the game starts up
func _load_coins():
	if FileAccess.file_exists(coin_save_path):
		var file = FileAccess.open(coin_save_path, FileAccess.READ)
		coins = file.get_var(coins)

# Once the game closes, it should save the amount of coins
func _notification(what: int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_coins()

# MAIN MENU BUTTONS ############################################################
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

# If the shop button is clicked, the shop will pop up
# And all icons would disapepar
func _on_shop_icon_button_pressed() -> void:
	shop_inventory.visible = true
	$"Action Buttons".visible = false

# Once the x is clicked, the shop will close
func _on_shop_inventory_x_pressed() -> void:
	shop_inventory.visible = false
	$"Action Buttons".visible = true

# BUYING BUTTONS FOR THE SHOP ##################################################
# Once the strawberry buy button is pressed
func _on_strawberry_buy_button_pressed() -> void:
	# Subtract how much the strawberry is
	coins = coins - 5
	_update_coin_label() # Update the coin label
	# $"Shop/Strawberry".visible = false # Setting the shop strawberry to invisible
	$"Inventory Panel/Strawberry".visible = true # Putting back the original strwaberry

# Once the cookie buy button has been pressed
func _on_cookie_buy_button_pressed() -> void:
	coins = coins - 10
	_update_coin_label()
	$"Inventory Panel/Cookie".visible = true

# Once the lettuce buy button has been pressed
func _on_lettuce_buy_button_pressed() -> void:
	coins = coins - 15
	_update_coin_label()
	$"Inventory Panel/Lettuce".visible = true

# Once the toilet paper button has been pressed
func _on_toilet_paper_buy_button_pressed() -> void:
	coins = coins - 10
	_update_coin_label()
	$"Bathroom Inventory Panel/Toilet Paper".visible = true

# Once the shower sponge button has been pressed
func _on_shower_sponge_buy_button_pressed() -> void:
	coins = coins - 10
	_update_coin_label()
	$"Shower Inventory Panel/Shower Sponge".visible = true
