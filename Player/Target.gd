extends Area

func _on_Target_body_entered(body):
	if body.name == "Friend":
		body.curr_state = body.STATES.STOP

func _on_Target_body_exited(body):
	pass


