extends Area


func _ready():
	connect("body_entered", self, "enable_camera")

func enable_camera(body):
	if body.name != "Player":
		return
	if has_node("Camera"):
		var cam = get_node("Camera")
		cam.make_current()
		if cam.has_method("set_target"):
			if body.name == "Player":
				cam.set_target(body)
			
#		var listener = get_node("Camera/Listener")
#		if cam.is_current():
#			listener.make_current()
#		else:
#			listener.clear_current()
#

