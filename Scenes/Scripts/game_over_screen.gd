extends Node2D

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_cook_button_pressed() -> void:
	visible = false
