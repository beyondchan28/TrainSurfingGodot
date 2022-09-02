extends PathFollow


export var speed = 2

var damage = 1

onready var reset_pos = get_parent().get_parent().get_parent().get_node("ResetPosition")

func _process(delta):
	set_offset(get_offset() + speed * delta)

func play_sound():
	$HittingSoundEffect.play()

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = reset_pos.get_global_transform().origin
		body.noticed(damage)
	if body.name == "Ally":
		body.current_state = body.STATES.LOST
		play_sound()

func _on_RobotArea_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = reset_pos.get_global_transform().origin
		body.noticed(damage)
	if body.name == "Ally":
		play_sound()
		body.current_state = body.STATES.LOST
