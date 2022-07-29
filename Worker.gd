extends KinematicBody

var velocity: Vector3
export var speed = 5

onready var stop_detector = $StopArea 

var curr_state
var distance
var target

export(Array, float) var start_point
export(Array, float) var end_point



enum STATES{WALK, STOP}

func _ready():
	target = get_parent().get_node("Player")
	curr_state = STATES.STOP


func _process(delta):
	var target_pos = target.global_transform.origin + Vector3.UP * 1.5
	var self_pos = self.global_transform.origin
	#var direction_to_player = self_pos.direction_to(target_pos)
	
	var start_pos = Vector3(start_point[0], start_point[1], start_point[2])
	var end_pos = Vector3(end_point[0], end_point[1], end_point[2])
	
	var self_to_start = self_pos.distance_to(start_pos)
	var start_to_end = start_pos.direction_to(end_pos)
	
	if curr_state == STATES.WALK:
		velocity = self_pos.direction_to(target_pos).normalized() #not uunderstand
		calculate_distance(target_pos, velocity)
		state_control(target_pos, self_pos)
		
	elif curr_state == STATES.STOP:
		if self_to_start > 1:
			velocity = self_pos.direction_to(start_pos).normalized() #not uunderstand
			calculate_distance(start_pos, velocity)
		elif self_to_start <= 1:
			velocity = start_pos.direction_to(end_pos)#not uunderstand
			calculate_distance(end_pos, velocity)


func calculate_distance(target_pos, velocity):
	move_and_slide(velocity * speed, Vector3.UP)
	look_at(target_pos, Vector3.UP)


func state_control(target_pos, self_pos):
	var distance = self_pos.distance_to(target_pos)
	#print(distance)
	if distance > 15:
		curr_state = STATES.STOP

#func patrol(self_pos, start, end):
#	var direction_to_point
#	var self_to_point = distance(self_pos, start)
#	var point_to_point = distance(start, end)
#
#	if self_post == start:
#
##	if distance_to_start_point <= 1 :
##		direction_to_point = self_pos.direction_to(end)
##	elif distance_to_end_point <= 1 :
##		direction_to_point = self_pos.direction_to(start)
##	return direction_to_point.normalized()

func distance(self_pos, target_pos):
	return self_pos.distance_to(target_pos)

func _on_StopArea_body_entered(body):
	if stop_detector.overlaps_body(body):
		curr_state = STATES.STOP

func _on_VisionArea_body_entered(body):
	if body.name == "Player":
		curr_state = STATES.WALK
