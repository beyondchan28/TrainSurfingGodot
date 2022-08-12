extends RigidBody

export(float) var velocity
export(NodePath) onready var target_node_1 = get_node(target_node_1)
export(NodePath) onready var patrol_point_1 = get_node(patrol_point_1) as Position3D
export(NodePath) onready var patrol_point_2 = get_node(patrol_point_2) as Position3D

onready var graphic = $Graphic

enum STATES {CHASE, PATROL_FWD, PATROL_BWD, STOP}

onready var patrol_1 = patrol_point_1.global_transform.origin
onready var patrol_2 = patrol_point_2.global_transform.origin
var current_state = STATES.STOP

var count = 0

func _physics_process(_delta):
	# Query the `NavigationAgent` to know the next free to reach location.
	var self_pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	var patrol_1 = patrol_point_1.global_transform.origin
	var patrol_2 = patrol_point_2.global_transform.origin
	if self_pos.distance_to(target_pos) < 20 and current_state == STATES.CHASE:
		set_target_location(target_pos)
	elif self_pos.distance_to(target_pos) > 20 and current_state == STATES.CHASE:
		current_state = STATES.PATROL_FWD
	elif current_state == STATES.PATROL_FWD :
		set_target_location(patrol_1)
	elif current_state == STATES.PATROL_BWD :
		set_target_location(patrol_2)
	if current_state != STATES.STOP:
		self.set_sleeping(false)
		update_location(self_pos)
	elif current_state == STATES.STOP:
		self.set_sleeping(true)
	
func update_location(self_pos):
	var target = $NavigationAgent.get_next_location()
	var n = $RayCast.get_collision_normal()
	if n.length_squared() < 0.1:
		n = Vector3(0, 1, 0)
	var vel = (target - self_pos).slide(n).normalized() * velocity
#	print(vel)
	set_linear_velocity(vel)
	set_look_at(target)
	

func set_target_location(pos):
	$NavigationAgent.set_target_location(pos)

func set_look_at(_target):
	graphic.look_at(_target, Vector3.UP * 5)

func reached():
	return count

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		current_state = STATES.CHASE


func _on_NavigationAgent_target_reached():
	if current_state == STATES.PATROL_FWD:
		current_state = STATES.PATROL_BWD
		count = 0
	elif current_state == STATES.PATROL_BWD:
		current_state = STATES.PATROL_FWD
		count = 1


