extends Node2D

# Variables that will hold the pet's stats 
# This includes hunger, cleanliness, and bathroom
var hunger := 100
var cleanliness := 100
var bathroom := 100

# These are to cap the max of the variables above
const MAX_STAT := 100
# This const, you cna change how fast you want each bar to decay for testing purposes or other
# purposes. For right now, it is set to every hour, it loses 10 points.
# This is how OFTEN each bar decays
const DECAY_INTERVAL := 3600.0 # 1 hour in seconds 
# This is how MUCH each bar decays
const DECAY_RATE := 10
# This is if any bar reaches 0, the pet will die
const CRITICAL_LEVEL := 0

# creating a name/reference for the timer
@onready var decay_timer = $Timer

# this begins the timer when the scene begins
func _ready():
	decay_timer.wait_time = DECAY_INTERVAL
	decay_timer.start()

# Once the game starts, this begins the decay automatically
func _on_timer_timeout() -> void:
	# The hunger begins to decay
	hunger = max(0, hunger - DECAY_RATE)
	# Cleanliness begins to decay
	cleanliness = max(0, cleanliness - DECAY_RATE)
	# Bathroom begins to decay as well
	bathroom = max(0, bathroom - DECAY_RATE)

# Thhis is to create a drop target over the pet so the
# Food items can be dragged and dropped 
func _can_drop_data(position, data):
	return data.has("Value")

# This is to actually have the pet react to the item
# That is getting dropped
func _drop_data(position, data):
	var food_value = data["Value"]
	hunger = min(100, hunger + food_value)
	# TODO: create an animation that shows that the
	# pet has eaten the piece of foood

# This checks the stats if they get too low
func _check_pet_status():
	if hunger <= CRITICAL_LEVEL:
		_pet_die("Too Hungry")
	elif cleanliness <= CRITICAL_LEVEL:
		_pet_die("Too Dirty")
	elif bathroom <= CRITICAL_LEVEL:
		_pet_die("Had an Accident")

# This is the game over screen, if the pet dies
func _pet_die(reason: String):
	# Possible instead of printing out on the console the pet died,
	# It would print it out onto the screen. That can be for later 
	print("Pet died because: ", reason, ".")
	get_tree().paused = true # This pauses the game
	# TOOD: Need to add a game over screen
	# Possibly even a restart button

# This is for testing
# Printing out the stats so we can keep track or debug
func _print_stats():
	print("Hunger: ", hunger, "| Cleanliness: ", cleanliness, "| Bathroom: ", bathroom)
