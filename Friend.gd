extends KinematicBody

onready var face_target_y = $FaceTargetY

var target
var velocity: Vector3
var speed = 9

onready var stop_detector = $StopArea 

var curr_state
var distance

enum STATES{WALK, STOP}

func _ready():
	target = get_parent().get_node("Player")
	curr_state = STATES.STOP


func _process(delta):
	var target_pos = target.global_transform.origin
	var self_pos = self.global_transform.origin
	var direction = self_pos.direction_to(target_pos)
	
	face_target_y.face_point(target_pos, delta)
	
	velocity = direction.normalized() #not uunderstand
	state_control(target_pos, self_pos)
	calculate_distance(self_pos, target_pos, velocity)


func calculate_distance(self_pos, target_pos, velocity):
	if curr_state == STATES.WALK:
		move_and_slide(velocity * speed, Vector3.UP)
	else:
		curr_state = STATES.STOP

func state_control(target_pos, self_pos):
	var distance = self_pos.distance_to(target_pos)
	#print(distance)
	if distance > 10  and curr_state == STATES.STOP:
		curr_state = STATES.WALK
	if distance < 5 or distance > 20:
		curr_state = STATES.STOP
		

func _on_StopArea_body_entered(body):
	if stop_detector.overlaps_body(body):
		curr_state = STATES.STOP
