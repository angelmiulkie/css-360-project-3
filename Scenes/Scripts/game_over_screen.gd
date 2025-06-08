extends Node2D

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_screen.tscn")
