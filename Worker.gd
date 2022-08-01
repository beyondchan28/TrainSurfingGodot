extends KinematicBody

var velocity: Vector3
export var speed = 5

onready var stop_detector = $StopArea 

var curr_state
var distance
var target

export(Array, float) var start_point
export(Array, float) var end_point

var path = []
var path_node = 0
onready var nav = get_parent()

enum STATES{WALK, STOP, PATROL_FWD, PATROL_BWD}

func _ready():
	target = get_parent().get_parent().get_node("Player")
	curr_state = STATES.WALK


func _physics_process(delta):
	var target_pos = target.global_transform.origin 
	var self_pos = self.global_transform.origin
	
	var start_pos = Vector3(start_point[0], start_point[1], start_point[2])
	var end_pos = Vector3(end_point[0], end_point[1], end_point[2])
	
	var self_to_start = self_pos.distance_to(start_pos)
	var self_to_end = self_pos.distance_to(end_pos)
	
	if curr_state == STATES.WALK:
#		calculate_distance(self_pos, target_pos, velocity)
		look_at(target_pos, Vector3.UP)
		pathfinding(delta)
		#state_control(target_pos, self_pos)
		
		
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

func pathfinding(delta):
	if path_node < path.size():
		var direction = (path[path_node] - self.global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			

func move_to(target_pos):
	path = nav.get_simple_path(self.global_transform.origin, target_pos)
	path_node = 0


func _on_Timer_timeout():
	move_to(target.global_transform.origin)
