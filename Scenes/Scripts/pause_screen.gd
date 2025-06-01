extends Node2D
# Emitting a signal to show that we want to save
signal save_requested

# Once the quit button is pressed
func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Once the resume button is pressed
func _on_resume_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Once the save button has been pressed, then it'll save
func _on_save_button_pressed() -> void:
	print("Save Button Pressed!")
	emit_signal("save_requested")
