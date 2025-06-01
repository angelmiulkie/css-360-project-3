extends ProgressBar

var parent # this is the parent class aka the pet

# Health variables
var max_value_amount
var min_value_amount
 
func _ready():
	parent = get_parent()
	max_value_amount = parent.MAX_STAT
	min_value_amount = parent.CRITICAL_LEVEL

func process(delta):
	self.value = parent.hunger
