extends PathFollow


export var speed = 2
onready var reset_pos = get_parent().get_parent().get_node("ResetPosition")

func _process(delta):
	set_offset(get_offset() + speed * delta)

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = reset_pos.get_global_transform().origin
	if body.name == "Ally":
		body.current_state = body.STATES.LOST

func _on_RobotArea_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = reset_pos.get_global_transform().origin
	if body.name == "Ally":
		body.current_state = body.STATES.LOST
