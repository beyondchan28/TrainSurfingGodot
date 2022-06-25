extends KinematicBody

onready var face_target_y = $FaceTargetY

var target
var velocity: Vector3
var speed = 9

onready var player = get_parent().get_node("Player")

var curr_state
var distance

enum STATES{WALK, STOP}

func _ready():
	target = get_parent().get_node("Player/Pivot/Target")
	curr_state = STATES.WALK


func _process(delta):
	var target_pos = target.global_transform.origin
	var self_pos = self.global_transform.origin
	var direction = self_pos.direction_to(target_pos)
	
	face_target_y.face_point(target_pos, delta)
	
	velocity = direction.normalized() #not uunderstand
	state_control(target_pos, self_pos)
	calculate_distance(self_pos, target_pos, velocity, delta)


#need to :  reach the area node then stop and will be able to walk again until the distance is 5 
func calculate_distance(self_pos, target_pos, velocity, delta):
	distance = self_pos.distance_to(target_pos)
	#print(distance)
	if curr_state == STATES.WALK:
		global_translate(velocity * speed * delta)
	else:
		curr_state = STATES.STOP

func state_control(target_pos, self_pos):
	var distance = self_pos.distance_to(target_pos)
	#print(distance)
	if distance > 10:
		curr_state = STATES.WALK
