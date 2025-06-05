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
var last_coin_time := 0


# Assigning the shop to buy items
@onready var shop_scene = preload("res://Scenes/shop.tscn")

# To ensure that the bars are updating once the game starts
@onready var hunger_bar = $"Pet/Hunger Bar"

# This is to make it so the funds pop up when they player doesn't have enough 
# Funds to be able to buy an item 
@onready var funds_popup = preload("res://Scenes/not_enough_funds_pop_up.tscn").instantiate()

# READY ########################################################################
func _ready():
	var pet_node = $Pet
	pet_node.hunger_changed.connect(_on_hunger_changed)

	# Load and update coins (includes offline coin gain)
	_load_coins()
	_update_coin_label()

	# Set coin timer interval based on mode
	if Global.is_speedrun:
		coin_timer.wait_time = 30.0
	else:
		coin_timer.wait_time = 300.0

	# Start coin timer
	coin_timer.timeout.connect(_on_coin_timer_timeout)
	coin_timer.start()

	# If coins are at or below zero, reset label
	if coins <= 0:
		print("No More Coins Left!")
		coins = 0
		_update_coin_label()

	# Hook up pause screen save signal
	var pause_screen = $"Pause Screen"
	if pause_screen:
		print("Connecting pause_screen save_requested signal")
		pause_screen.connect("save_requested", Callable(self, "_save_game"))
	
	# This is for the funds pop up
	add_child(funds_popup)


# SIGNAL FUNCTIONS! ############################################################
# To ensure that the hunger works 
func _on_hunger_changed(new_value: int) -> void:
	print("Updating bar to new value: ", new_value)
	hunger_bar.value = new_value

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
	file.store_var(Time.get_unix_time_from_system())


# Then loading the coins once the game starts up
func _load_coins():
	if FileAccess.file_exists(coin_save_path):
		var file = FileAccess.open(coin_save_path, FileAccess.READ)
		
		# If the file is corrupted
		if file.eof_reached():
			coins = 50 # Default coins
			last_coin_time = 0
			return
		
		coins = file.get_var()
		if file.eof_reached():
			last_coin_time = 0
		else:
			var maybe_time = file.get_var()
			if maybe_time == null:
				last_coin_time = 0
			else:
				last_coin_time = maybe_time

		# Set values based on mode (no ternary)
		var coin_interval = 300
		var coin_reward = 5
		if Global.is_speedrun:
			coin_interval = 30
			coin_reward = 2

		# Offline coin generation
		var now = Time.get_unix_time_from_system()
		var seconds_passed = now - last_coin_time
		var coins_earned = int(seconds_passed / coin_interval) * coin_reward

		if coins_earned > 0:
			print("You earned", coins_earned, "coins while offline!")
			coins += coins_earned


# To check if there are any money left to spend
func _no_more_coins():
	if coins <= 0:
		print("No More Coins Left!")
		coins = 0
		_update_coin_label()
		return true
	else:
		return false

# Checks to see if they can even afford the item
func _can_afford(amount: int) -> bool:
	return coins >= amount

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
	var cost = 5
	if _can_afford(cost):
		coins = coins - cost
		_update_coin_label()
	else: 
		funds_popup._show_message("Not Enough Funds!")
	# $"Shop/Strawberry".visible = false # Setting the shop strawberry to invisible
	
	# Now checking if they have any coins at all
	_no_more_coins()
	if _no_more_coins() == true:
		$"Inventory Panel/Strawberry".visible = false
	else: 
		$"Inventory Panel/Strawberry".visible = true # Putting back the original strawberry
	_save_coins()

# Once the cookie buy button has been pressed
func _on_cookie_buy_button_pressed() -> void:
	var cost = 10
	if _can_afford(cost):
		coins = coins - cost
		_update_coin_label()
	else: 
		funds_popup._show_message("Not Enough Funds!")
	
	# Now checking if they have any coins at all
	_no_more_coins()
	if _no_more_coins() == true:
		$"Inventory Panel/Cookie".visible = false
	else: 
		$"Inventory Panel/Cookie".visible = true
	_save_coins()

# Once the lettuce buy button has been pressed
func _on_lettuce_buy_button_pressed() -> void:
	var cost = 15
	if _can_afford(cost):
		coins = coins - cost
		_update_coin_label()
	else: 
		funds_popup._show_message("Not Enough Funds!")
	
	# Now checking if they have any coins at all
	_no_more_coins()
	if _no_more_coins() == true:
		$"Inventory Panel/Lettuce".visible = false
	else: 
		$"Inventory Panel/Lettuce".visible = true
	_save_coins()

# Once the toilet paper button has been pressed
func _on_toilet_paper_buy_button_pressed() -> void:
	var cost = 10
	if _can_afford(cost):
		coins = coins - cost
		_update_coin_label()
	else: 
		funds_popup._show_message("Not Enough Funds!")
	
	# Now checking if they have any coins at all
	_no_more_coins()
	if _no_more_coins() == true:
		$"Bathroom Inventory Panel/Toilet Paper".visible = false
	else: 
		$"Bathroom Inventory Panel/Toilet Paper".visible = true
	_save_coins()

# Once the shower sponge button has been pressed
func _on_shower_sponge_buy_button_pressed() -> void:
	var cost = 10
	if _can_afford(cost):
		coins = coins - cost
		_update_coin_label()
	else: 
		funds_popup._show_message("Not Enough Funds!")
	
	# Now checking if they have any coins at all
	_no_more_coins()
	if _no_more_coins() == true:
		$"Shower Inventory Panel/Shower Sponge".visible = false
	else: 
		$"Shower Inventory Panel/Shower Sponge".visible = true
	_save_coins()

# If the home icon is pressed, the pause screen menu will come up
func _on_home_icon_button_pressed() -> void:
	$"Pause Screen".visible = true

# Creating a save function that saves everything
func _save_game():
	print("Entered game save")
	_save_coins()
	$Pet._save_stats()
	print("Game Saved!")
