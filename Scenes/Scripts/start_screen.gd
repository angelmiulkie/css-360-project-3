extends Node2D

@onready var game_over_screen = get_node("GameOverScreen")

func _ready():
	if Global.game_over:
		$"GameOverScreen".visible = true
		Global.game_over = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed():
	Global.is_speedrun = false
	Global.decay_interval = 3600.0
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_speedrun_button_pressed():
	Global.is_speedrun = true
	Global.decay_interval = 5.0
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
