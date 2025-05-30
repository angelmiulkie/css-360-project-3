extends Node2D

# Variables that will hold the pet's stats 
# This includes hunger, cleanliness, and bathroom
var hunger := 100
var cleanliness := 100
var bathroom := 100

# The location of the save file
const save_path := "user://stats.save"

# These are to cap the max of the variables above
const MAX_STAT := 100
# This const, you cna change how fast you want each bar to decay for testing purposes or other
# purposes. For right now, it is set to every hour, it loses 10 points.
# This is how OFTEN each bar decays
const DECAY_INTERVAL := 3600.0 # 1 hour in seconds 
# Alternate value for testing, possible speedrun mode
const DECAY_INTERVAL_SPEEDRUN := 1.0
# This is how MUCH each bar decays
const DECAY_RATE := 10
# This is if any bar reaches 0, the pet will die
const CRITICAL_LEVEL := 0

# creating a name/reference for the timer
@onready var decay_timer = $Timer

# this begins the timer when the scene begins
func _ready():
	if FileAccess.file_exists(save_path):
		_load_stats()
	decay_timer.wait_time = DECAY_INTERVAL_SPEEDRUN
	decay_timer.start()

# Once the game starts, this begins the decay automatically
func _on_timer_timeout() -> void:
	print(hunger)
	# The hunger begins to decay
	hunger = max(0, hunger - DECAY_RATE)
	# Cleanliness begins to decay
	cleanliness = max(0, cleanliness - DECAY_RATE)
	# Bathroom begins to decay as well
	bathroom = max(0, bathroom - DECAY_RATE)
	_check_pet_status()

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
	else:
		_save_stats()

# This is the game over screen, if the pet dies
func _pet_die(reason: String):
	# Possible instead of printing out on the console the pet died,
	# It would print it out onto the screen. That can be for later 
	print("Pet died because: ", reason, ".")
	DirAccess.remove_absolute(save_path) # Deletes the save file
	get_tree().paused = true # This pauses the game
	# TOOD: Need to add a game over screen
	# Possibly even a restart button

# This is for testing
# Printing out the stats so we can keep track or debug
func _print_stats():
	print("Hunger: ", hunger, "| Cleanliness: ", cleanliness, "| Bathroom: ", bathroom)

func _save_stats():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(hunger)
	file.store_var(cleanliness)
	file.store_var(bathroom)

func _load_stats():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		hunger = file.get_var(hunger)
		cleanliness = file.get_var(cleanliness)
		bathroom = file.get_var(bathroom)
		
