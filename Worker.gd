extends KinematicBody

onready var face_target_y = $FaceTargetY

var velocity: Vector3
export var speed = 5

onready var stop_detector = $StopArea 

var curr_state
var distance
var target

onready var vision_manager = $VisionManager


enum STATES{WALK, STOP}

func _ready():
	target = get_parent().get_node("Player")
	curr_state = STATES.STOP


func _process(delta):
	var target_pos = target.global_transform.origin + Vector3.UP * 1.5
	var self_pos = self.global_transform.origin
	var direction = self_pos.direction_to(target_pos)
	
	
	velocity = direction.normalized() #not uunderstand
	
	
	if vision_manager.in_vision(target_pos) and vision_manager.has_line_of_sight(target_pos):
		calculate_distance(self_pos, target_pos, velocity)
		state_control(target_pos, self_pos)
		face_target_y.face_point(target_pos, delta)
		
		

func calculate_distance(self_pos, target_pos, velocity):
	if curr_state == STATES.WALK:
		move_and_slide(velocity * speed, Vector3.UP)
	else:
		curr_state = STATES.STOP

func state_control(target_pos, self_pos):
	var distance = self_pos.distance_to(target_pos)
	#print(distance)
	if distance > 8 and curr_state == STATES.STOP:
		curr_state = STATES.WALK
	if distance < 5 or distance > 15:
		curr_state = STATES.STOP
		

func _on_StopArea_body_entered(body):
	if stop_detector.overlaps_body(body):
		curr_state = STATES.STOP
