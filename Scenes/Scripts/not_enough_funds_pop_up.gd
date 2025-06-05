extends CanvasLayer

# Creating the variables
@onready var label = $"Pop Up Label"
@onready var timer = $"Fade Timer"

# Function that plays the message when it comes up
func _show_message(msg: String, duration := 1.5):
	label.text = msg
	label.visible = true
	timer.wait_time = duration
	timer.start()

# Creating the function that makes the message disappear
# After a while
func _on_fade_timer_timeout() -> void:
	label.visible = false
