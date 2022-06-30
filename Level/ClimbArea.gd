extends Area

class_name Ladder

func _on_ClimbArea_body_entered(body):
	if body.name == "Player" :
		body.climb_array.append(self)
		#body.curr_state = body.STATES.CLIMB


func _on_ClimbArea_body_exited(body):
	if body.name == "Player":
		body.climb_array.erase(self)
		if body.climb_array.size() == 0:
			body.curr_state = body.STATES.IDLE
