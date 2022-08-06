extends KinematicBody

onready var target: KinematicBody = get_parent().get_parent().get_node("Player")
onready var nav: Navigation = get_parent()

var move_speed = 10.0
var move_vec = Vector3.ZERO

func _physics_process(delta):
	update_move_vec()
	move_and_slide(move_vec * move_speed * delta, Vector3.UP)
	
func update_move_vec():
	var path = nav.get_simple_path(global_transform.origin, target.global_transform.origin)
	if path.size() > 1:
		var dir = path[1] - global_transform.origin
		dir = dir.normalized()
		move_vec = dir
