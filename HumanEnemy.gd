extends RigidBody

var velocity = 3
export(NodePath) onready var target_node_1 = get_node(target_node_1)
export(NodePath) onready var patrol_point_1 = get_node(patrol_point_1) as Position3D
export(NodePath) onready var patrol_point_2 = get_node(patrol_point_2) as Position3D

onready var graphic = $Graphic
onready var anim = $Graphic/AnimationPlayer
onready var detector = $Graphic/DetectionArea
onready var notice_sound = $NoticeSound

const SOUND_1 = preload("res://Sound Audio/SFx/Worker Voices/VOICE LINES/COME HERE.wav")
const SOUND_2 = preload("res://Sound Audio/SFx/Worker Voices/VOICE LINES/DONT RUN.wav")
const SOUND_3 = preload("res://Sound Audio/SFx/Worker Voices/VOICE LINES/LEMME CATCH YOU.wav")


enum STATES {CHASE, PATROL_FWD, PATROL_BWD, STOP}

export(STATES) var current_state = STATES.PATROL_FWD

var count = 0

var damage = 1

func _ready():
	connect("body_entered", self, "attack", [], 4)
	

func _physics_process(_delta):
	# Query the `NavigationAgent` to know the next free to reach location.
	var self_pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	var patrol_1 = patrol_point_1.global_transform.origin
	var patrol_2 = patrol_point_2.global_transform.origin
	if self_pos.distance_to(target_pos) < 15 and target_node_1.move_speed == 10 or target_node_1.curr_state == target_node_1.STATES.JUMP:
		current_state = STATES.CHASE
	if self_pos.distance_to(target_pos) < 15 and current_state == STATES.CHASE:
		set_target_location(target_pos)
		if self_pos.distance_to(target_pos) < 2:
			target_node_1.health_manager.emit_signal("dead")
			current_state = STATES.STOP
	elif self_pos.distance_to(target_pos) > 15 and current_state == STATES.CHASE:
		current_state = STATES.PATROL_FWD
	elif current_state == STATES.PATROL_FWD :
		set_target_location(patrol_1)
	elif current_state == STATES.PATROL_BWD :
		set_target_location(patrol_2)
	if current_state != STATES.STOP:
		self.set_sleeping(false)
		update_location(self_pos)
	elif current_state == STATES.STOP:
		play_anim("Idle")
		self.set_sleeping(true)
	
	if current_state == STATES.CHASE:
		velocity = 6
		play_anim("Run")
	elif current_state == STATES.PATROL_FWD or current_state == STATES.PATROL_BWD:
		velocity = 3
		play_anim("Walk")

func update_location(self_pos):
	var target = $NavigationAgent.get_next_location()
	var n = $RayCast.get_collision_normal()
	var abs_normal = Vector3(abs(n.x), abs(n.y), abs(n.z))
	var inv_normal = Vector3.ONE - abs_normal
#	if n.length_squared() < 0.1:
#		n = Vector3(0, 1, 0)
	var vel = ((target - self_pos) * inv_normal).normalized() * velocity
	set_linear_velocity(vel)
	set_look_at(target)
	

func set_target_location(pos):
	$NavigationAgent.set_target_location(pos)

func set_look_at(_target):
	graphic.look_at(_target, Vector3.UP * 5)

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		current_state = STATES.CHASE
		emit_signal("body_entered")
		

func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		connect("body_entered", self, "attack", [], 4)

func attack():
	target_node_1.noticed(damage)
#	play_sound()
	print(self.name)
	if count == 3:
		count = 0
	else:
		count += 1
	
	

func _on_NavigationAgent_target_reached():
	if current_state == STATES.PATROL_FWD:
		current_state = STATES.PATROL_BWD
	elif current_state == STATES.PATROL_BWD:
		current_state = STATES.PATROL_FWD

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func play_sound():
	if count == 0:
		notice_sound.set_stream(SOUND_1)
		notice_sound.play()
	elif count == 1:
		notice_sound.set_stream(SOUND_2)
		notice_sound.play()
	elif count == 2:
		notice_sound.set_stream(SOUND_3)
		notice_sound.play()

func _on_NavigationAgent_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)


