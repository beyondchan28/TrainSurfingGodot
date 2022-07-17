extends Area

export(Resource) var _dialogue = _dialogue as Dialogue


func _on_TelephoneArea_body_entered(body):
	if body.name == "Player":
		GameEvents.emit_signal("dialog_initiated", _dialogue)
