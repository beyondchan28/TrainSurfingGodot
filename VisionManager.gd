extends Spatial


export var vision_arc = 60.0

func in_vision(point: Vector3):
	var forward = -self.global_transform.basis.z
	var self_pos = self.global_transform.origin
	var dir_to_point = point - self_pos
	return rad2deg(dir_to_point.angle_to(forward)) <= vision_arc/2.0

func has_line_of_sight(point: Vector3):
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(self.global_transform.origin, point, [], 2)
	if result:
		return false
	return true
