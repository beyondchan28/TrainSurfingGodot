extends KinematicBody

onready var target: Spatial = get_parent().get_node("Player/Target")
onready var nav: Navigation = get_parent().get_node("Navigation")

var move_speed = 10.0
var move_vec: Vector3

func _physics_process(delta):
	update_move_vec()
	global_translate(move_vec * move_speed * delta)
	

func update_move_vec():
	var path = nav.get_simple_path(global_transform.origin, target.global_transform.origin)
	if path.size() > 1:
		var dir: Vector3 = path[1] - global_transform.origin
#		dir.y = 0.0
		dir.normalized()
		move_vec = dir
