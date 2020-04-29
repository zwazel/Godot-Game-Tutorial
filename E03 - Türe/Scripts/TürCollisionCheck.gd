extends StaticBody

var rotatePoint

func _ready():
	rotatePoint = get_parent().get_parent()
	
func open_door(hat_key):
	if rotatePoint.has_method("open"):
		rotatePoint.open(hat_key)
