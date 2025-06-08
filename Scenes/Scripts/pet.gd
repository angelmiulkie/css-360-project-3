extends Node2D

# Emitting singals for hunger
signal hunger_changed(new_hunger)
# Emitting signals for bathroom
signal bathroom_changed(new_bathroom)
# Emitting singals for shower
signal shower_changed(new_shower)

# Variables that will hold the pet's stats 
# This includes hunger, cleanliness, and bathroom
var hunger := 100
var cleanliness := 100
var bathroom := 100

# When stats were last saved, in Unix time
var last_save_time := 0

# Paths to save data, set in _ready() based on mode
var save_path := ""
var coin_path := ""
var inventory_path := ""

# These are to cap the max of the variables above
var MAX_STAT = 100
# This const, you cna change how fast you want each bar to decay for testing purposes or other
# purposes. For right now, it is set to every hour, it loses 10 points.
# This is how OFTEN each bar decays
var DECAY_INTERVAL := 3600.0 # 1 hour in seconds 
# This is how MUCH each bar decays
var DECAY_RATE := 10
# This is if any bar reaches 0, the pet will die
var CRITICAL_LEVEL = 0

# creating a name/reference for the timer
@onready var decay_timer = $Timer

# READY #######################################################################
# this begins the timer when the scene begins 
func _ready():
	if Global.is_speedrun:
		save_path = Global.speedrun_save_path
		coin_path = Global.speedrun_coin_save_path
		inventory_path = Global.speedrun_inventory_save_path
	else:
		save_path = Global.normal_save_path
		coin_path = Global.normal_coin_save_path
		inventory_path = Global.normal_inventory_save_path
	# File Saving Mechanisms - Daniel!
	if FileAccess.file_exists(save_path):
		_load_stats() # loads existing save
	else:
		# creates new save, important if player quits within first interval
		_save_stats()
	
	# Emitting signals so the health bar UIs get updated right away
	emit_signal("hunger_changed", hunger)
	emit_signal("bathroom_changed", bathroom)
	emit_signal("shower_changed", cleanliness)
	
	# Skips ahead a number of intervals based on how much time passed
	# since the last save was made
	var cur_time = Time.get_unix_time_from_system()
	var num_intervals = int((cur_time - last_save_time) / Global.decay_interval)
	# Skip ahead for time passed since last session
	for i in range(num_intervals):
		_on_timer_timeout()
		if not FileAccess.file_exists(save_path):
			break # Pet has died
	
	# Starts the timer
	decay_timer.wait_time = Global.decay_interval
	decay_timer.start()
	
	# For Testing
	print("Current Hunger:", hunger)
	print("Current Bathroom:", bathroom)
	print("Current Cleanliness:", cleanliness)
	print("Decay Interval is:" , Global.decay_interval)

# Once the game starts, this begins the decay automatically
func _on_timer_timeout() -> void:
	# The hunger begins to decay
	hunger = max(0, hunger - DECAY_RATE)
	# Cleanliness begins to decay
	cleanliness = max(0, cleanliness - DECAY_RATE)
	# Bathroom begins to decay as well
	bathroom = max(0, bathroom - DECAY_RATE)
	emit_signal("hunger_changed", hunger)
	emit_signal("bathroom_changed", bathroom)
	emit_signal("shower_changed", cleanliness)
	_check_pet_status()
	
# ALL PLAYER FUNCTIONS ########################################################
# Feeding the pet
func _feed(amount: int) -> void:
	hunger = min(MAX_STAT, hunger + amount)
	print("Feeding Pet, New Hunger: ", hunger)
	# TODO: create an animation that shows the pet eating
	emit_signal("hunger_changed", hunger)
	_check_pet_status()

# Letting the pet go to the bathroom
func _go_bathroom(amount: int) -> void:
	bathroom = min(MAX_STAT, bathroom + amount)
	print ("Cleaning Pet, New Bathroom: ", bathroom)
	# TODO: create an animation that shows the pet going to bathroom
	emit_signal("bathroom_changed", bathroom)
	_check_pet_status()

func _go_shower(amount: int) -> void:
	cleanliness = min(MAX_STAT, cleanliness + amount)
	print ("Showering pet, New Shower: ", cleanliness)
	#TODO: create an animation that shows the pet showering
	emit_signal("shower_changed", cleanliness)
	_check_pet_status()

# PET CHECKS ##################################################################
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
	# Deletes the save files
	DirAccess.remove_absolute(save_path)
	DirAccess.remove_absolute(coin_path)
	DirAccess.remove_absolute(inventory_path)
	get_tree().change_scene_to_file("res://Scenes/game_over_screen.tscn")

# This is for testing
# Printing out the stats so we can keep track or debug
func _print_stats():
	print("Hunger: ", hunger, "| Cleanliness: ", cleanliness, "| Bathroom: ", bathroom)

func _save_stats():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(hunger)
	file.store_var(cleanliness)
	file.store_var(bathroom)
	last_save_time = Time.get_unix_time_from_system() # sets to current time
	file.store_var(last_save_time)
	file.store_var(Global.decay_interval)

func _load_stats():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		hunger = file.get_var(hunger)
		cleanliness = file.get_var(cleanliness)
		bathroom = file.get_var(bathroom)
		last_save_time = file.get_var(last_save_time)
		Global.decay_interval = file.get_var(Global.decay_interval)
