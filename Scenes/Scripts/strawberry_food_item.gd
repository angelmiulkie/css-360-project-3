extends TextureRect

# variables that show how much each food value is
# and tahe name of the food
var food_value = 5
var food_name = "Strawberry"

# Creating a function that makes it so the strawberry
# is draggable
func _get_drag_data(position):
	# Creating a container Control to hold the preview
	var preview = Control.new()
	var size = Vector2(113, 113)
	preview.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	preview.set_size(size)
	
	# Creating the Visual Texture
	var drag_texture = TextureRect.new()
	
	drag_texture.texture = texture
	drag_texture.expand = true
	drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_texture.custom_minimum_size = Vector2(113, 113) # This is the size of the strawberry
	
	# Making the entire drag_texture fill the whole preview
	drag_texture.anchor_left = 0
	drag_texture.anchor_top = 0
	drag_texture.anchor_right = 1
	drag_texture.anchor_bottom = 1
	drag_texture.offset_left = 0
	drag_texture.offset_top = 0
	drag_texture.offset_right = 0
	drag_texture.offset_bottom = 0
	
	drag_texture.position = -size / 2
	preview.add_child(drag_texture)
	set_drag_preview(preview)
	
	# Hiding the original picture so it looks like we're
	# actually dragging the real strawberry 
	visible = false 
	
	var drag_data = {
		"Name": food_name,
		"Value": food_value,
		"Texture": self.texture
	}
	return drag_data

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		visible = true
