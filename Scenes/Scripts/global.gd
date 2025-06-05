extends Node

# Global variables that can be accessed from multiple script files
var decay_interval
# Use different save files for each mode
const normal_save_path := "user://data.save"
const speedrun_save_path := "user://data_speedrun.save"
const normal_coin_save_path := "user://coins.save"
const speedrun_coin_save_path := "user://coins_speedrun.save"
var is_speedrun := false
