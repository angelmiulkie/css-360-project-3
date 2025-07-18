extends TextureRect

# variables that show how much each food value is
# and tahe name of the food
var shower_value = 25
var shower_name = "Shower Sponge"
var original_position: Vector2
var was_dropped = false

func _ready():
	original_position = position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		grab_click_focus()

func _get_drag_data(position: Vector2) -> Variant:
	was_dropped = false 
	var preview = _create_preview()
	set_drag_preview(preview)
	visible = false
	return {
		"Name": shower_name,
		"Value": shower_value,
		"Texture": texture,
		"Source Node": self
	}

# Creating the preview that makes the strawberry draggable
func _create_preview():
	var preview = Control.new()
	var size = Vector2(113, 113)
	preview.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	preview.set_size(size)
	
	var drag_texture = TextureRect.new()
	drag_texture.texture = texture
	drag_texture.expand = true
	drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_texture.custom_minimum_size = size
	
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
	return preview

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not was_dropped:
			position = original_position
			visible = true
