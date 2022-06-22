extends Spatial



export var turn_speed = 100.0


func face_point(point: Vector3, delta):
	var l_point = to_local(point)
	l_point.y = 0.0
	var turn_dir = sign(l_point.x)
	var turn_amount = deg2rad(turn_speed + delta)
	var angle = Vector3.FORWARD.angle_to(l_point)
	
	if angle < turn_amount:
		turn_amount = angle
		
	rotate_object_local(Vector3.UP, -turn_amount * turn_dir)
