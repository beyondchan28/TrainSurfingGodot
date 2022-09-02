extends Camera

export var turn_speed = 60
export var follow_dist  = 5
export var follow = true
export var follow_speed = 2

var target = null

onready var listener = $Listener

func _physics_process(delta):
	#print(listener.is_current())
	if target == null:
		return
	
	var to_target = target.global_transform.origin - global_transform.origin
	var dist = to_target.length()
	var move_vec = to_target
	move_vec.y = 0
	to_target = to_target.normalized()
	
	if follow:
		var accel = dist - follow_dist
		global_transform.origin += accel * move_vec * follow_speed * delta
	
	var up = global_transform.basis.y
	var right = global_transform.basis.x
	
	var r_dot = to_target.dot(right)
	var u_dot = to_target.dot(up)
	
	rotation_degrees.y += turn_speed * -r_dot * delta
	rotation_degrees.x += turn_speed * u_dot * delta
	enable_listener()
	

func set_target(t):
	target = t

func enable_listener():
	if self.is_current():
		listener.make_current()
	else:
		listener.clear_current()
