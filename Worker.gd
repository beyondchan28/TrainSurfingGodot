extends KinematicBody

var velocity: Vector3
export var speed = 5

onready var stop_detector = $StopArea 

var curr_state
var distance
var target

export(Array, float) var start_point
export(Array, float) var end_point



enum STATES{WALK, STOP, PATROL_FWD, PATROL_BWD}

func _ready():
	target = get_parent().get_node("Player")
	curr_state = STATES.STOP


func _process(delta):
	var target_pos = target.global_transform.origin + Vector3.UP * 1.5
	var self_pos = self.global_transform.origin
	
	var start_pos = Vector3(start_point[0], start_point[1], start_point[2])
	var end_pos = Vector3(end_point[0], end_point[1], end_point[2])
	
	var self_to_start = self_pos.distance_to(start_pos)
	var self_to_end = self_pos.distance_to(end_pos)
	
	if curr_state == STATES.WALK:
		calculate_distance(self_pos, target_pos, velocity)
		state_control(target_pos, self_pos)
		
	elif curr_state == STATES.STOP:
		if self_to_start > 1:
			calculate_distance(self_pos, start_pos, velocity)
		else:
			curr_state = STATES.PATROL_FWD

	elif curr_state == STATES.PATROL_FWD:
		if self_to_end > 0.5 :
			calculate_distance(self_pos, end_pos, velocity)
		else:
			curr_state = STATES.PATROL_BWD
	elif curr_state == STATES.PATROL_BWD:
		if self_to_start > 0.5:
			calculate_distance(self_pos, start_pos, velocity)
		else:
			curr_state = STATES.PATROL_FWD

func calculate_distance(begin: Vector3, finish: Vector3, velocity):
	velocity = begin.direction_to(finish).normalized()
	move_and_slide(velocity * speed, Vector3.UP)
	look_at(finish, Vector3.UP)


func state_control(target_pos, self_pos):
	var distance = self_pos.distance_to(target_pos)

	if distance > 15:
		curr_state = STATES.STOP

func distance(self_pos, target_pos):
	return self_pos.distance_to(target_pos)


func _on_VisionArea_body_entered(body):
	if body.name == "Player":
		curr_state = STATES.WALK
