extends KinematicBody

const TURN_SPEED = 180
const GRAVITY = 98
const MAX_FALL_SPEED = 30
const JUMP_IMPULSE = 20
 
var y_velo = 0
var grounded = false
var move_speed = 5
var climb_speed = 5
var curr_state = STATES.IDLE

export(Resource) var _runtime_data = _runtime_data as RuntimeData

onready var collision_shape = $CollisionShape
onready var interact_area = $CollisionShape/InteractArea
onready var unclimb_area = $CollisionShape/UnclimbArea

onready var anim = $Pivot/AnimationPlayer

var climb_array = []

enum STATES{IDLE, JUMP, CROUCH, CLIMB, UNCLIMB}
 
func _physics_process(delta):
	var move_dir = 0
	var turn_dir = 0
	if _runtime_data.current_gameplay_state == Enums.GameplayState.FREEWALK:
		movement_input(move_dir, turn_dir, delta)
		run()
		jump()
		crouch()
		climber_detection()
	else:
		curr_state = STATES.IDLE
		move_dir = 0
		turn_dir = 0
		self.translation.y = 2
		anim.play("Idle")
	#print(curr_state)
	

func movement_input(move_dir, turn_dir, delta):
	if Input.is_action_pressed("move_forwards"):
		move_dir -= 1
	if Input.is_action_pressed("move_backwards"):
		move_dir += 1
	if Input.is_action_pressed("turn_right"):
		turn_dir -= 1
	if Input.is_action_pressed("turn_left"):
		turn_dir += 1
		
	rotation_degrees.y += turn_dir * TURN_SPEED * delta
	var move_vec = global_transform.basis.z * move_speed * move_dir
	move_vec.y = y_velo
	if curr_state == STATES.CLIMB :
		move_vec.z = -2
	elif curr_state == STATES.UNCLIMB:
		move_vec.z = 2

	move_and_slide(move_vec, Vector3(0, 1, 0))
	#print(move_vec)
	
	var was_grounded = grounded
	grounded = is_on_floor()
	climb_logic(move_vec)
	#animation idle, jump, walk, crouch, crouching and run here
	
	if not grounded and was_grounded:
		play_anim("Jump")
	if grounded:
		if move_vec.x == 0 and move_vec.z == 0 and curr_state == STATES.IDLE:
			play_anim("Idle")
		elif move_vec.x != 0 and move_vec.z != 0 and move_speed == 10:
			play_anim("Run")
		elif move_vec.x == 0 and move_vec.z == 0 and curr_state == STATES.CROUCH:
			play_anim("Crouch")
		elif move_vec.x != 0 and move_vec.z != 0 and curr_state == STATES.CROUCH:
			play_anim("Crouching")
		elif move_vec.x != 0 and move_vec.z != 0 and move_speed == 5:
			play_anim("Walk")
	
	y_velo -= GRAVITY * delta
	
	if curr_state != STATES.CLIMB and grounded:
		y_velo = -0.1
	if curr_state != STATES.UNCLIMB and y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED


func climb_logic(move_vec):
	if curr_state == STATES.CLIMB :
		y_velo = climb_speed
	if curr_state == STATES.CLIMB and curr_state == STATES.UNCLIMB:
		y_velo = -climb_speed
		

func climber_detection():
	if Input.is_action_pressed("climb") :
		var area_detected = interact_area.get_overlapping_areas()
		for areas in area_detected:
			if areas is Ladder:
				curr_state = STATES.CLIMB
	if Input.is_action_pressed("unclimb") :
		var unclimb_detected = unclimb_area.get_overlapping_areas()
		for areas in unclimb_detected:
			if areas is Ladder:
				curr_state = STATES.UNCLIMB

func jump():
	if is_on_floor() and curr_state != STATES.CROUCH and Input.is_action_just_pressed("jump") and grounded:
		curr_state = STATES.JUMP
		y_velo = JUMP_IMPULSE
	if Input.is_action_just_released("jump"):
		curr_state = STATES.IDLE

func crouch():
	var ms_changer = 3
	if is_on_floor()  and Input.is_action_pressed("crouch"):
		curr_state = STATES.CROUCH
		move_speed = ms_changer
		collision_shape.scale.z = 0.5
	elif Input.is_action_just_released("crouch") :
		move_speed = 5
		collision_shape.scale.z = 1
		curr_state = STATES.IDLE

func run():
	if is_on_floor() and Input.is_action_pressed("run"):
		move_speed = 10
		
	elif is_on_floor() and Input.is_action_just_released("run"):
		move_speed = 5
	else :
		return

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)
