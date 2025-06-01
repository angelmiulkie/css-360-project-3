extends ProgressBar

var parent # this is the parent class aka the pet

# Health variables
var max_value_amount
var min_value_amount
 
func _ready():
	parent = get_parent()
	max_value_amount = parent.MAX_STAT
	min_value_amount = parent.CRITICAL_LEVEL
	
	self.min_value = min_value_amount
	self.max_value = max_value_amount
	
	parent.connect("bathroom_changed", Callable(self, "_on_bathroom_changed"))
	self.value = parent.bathroom

func _on_bathroom_changed(new_bathroom):
	self.value = new_bathroom
