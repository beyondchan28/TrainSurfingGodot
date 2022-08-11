extends PathFollow


export var speed = 2
onready var reset_pos = get_parent().get_parent().get_node("ResetPosition").get_global_transform().origin

func _process(delta):
	set_offset(get_offset() + speed * delta)

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		body.global_transform.origin = reset_pos
	if body.name == "Ally":
		body.global_transform.origin = reset_pos
