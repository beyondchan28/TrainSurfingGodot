extends KinematicBody

export var max_speed = 6
export var gravity = 25
export var jump_impulse = 10
export var ladder_speed = 5

onready var pivot = $Pivot
onready var interact_area = $CollisionShape/InteractArea
onready var unclimb_area = $CollisionShape/UnclimbArea


var switch_logic = true
var velocity = -Vector3.ZERO

var climb_array = []
var curr_state = STATES.NORMAL

enum STATES{NORMAL, CLIMB, UNCLIMB}

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_movement(input_vector)
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	jump(switch_logic)
	crouch()
	run(switch_logic)
	#state_controler()
	climb()


func climb():
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
	

#func state_controler():
#	if curr_state == STATES.CLIMB:
#		unclimb_area.set_monitoring(false)
#	elif curr_state ==  STATES.UNCLIMB:
#		interact_area.set_monitoring(false)
#	else:
#		unclimb_area.set_monitoring(true)
#		interact_area.set_monitoring(true)
#
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	if curr_state == STATES.NORMAL:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.z = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forwards")

	return input_vector.normalized()

#landscape movement logic
func apply_movement(input_vector : Vector3):
	velocity.x = input_vector.x * max_speed
	velocity.z = input_vector.z * max_speed
	
	if input_vector != Vector3.ZERO and !is_on_wall():
		self.look_at(translation + input_vector, Vector3.UP)
	

#vertical movement logic
func apply_gravity(delta):
	if curr_state == STATES.NORMAL:
		velocity.y -= gravity * delta
	
	#climbing logic
	elif curr_state == STATES.CLIMB:
		velocity.y = ladder_speed
		velocity.z = -15
	elif curr_state == STATES.UNCLIMB:
		velocity.z = 2
		velocity.y = -ladder_speed
		

func run(can_run):
	if is_on_floor() and Input.is_action_pressed("run") and can_run:
		max_speed = 12
	elif is_on_floor() and Input.is_action_just_released("run"):
		max_speed = 6
	else :
		return

func jump(can_jump: bool):
	if is_on_floor() and Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = jump_impulse

func crouch():
	var ms_changer = 5
	if is_on_floor() and Input.is_action_pressed("crouch"):
		switch_logic = false
		max_speed = ms_changer
		self.scale.y = 0.5
	elif Input.is_action_just_released("crouch") :
		switch_logic = true
		max_speed = 6
		self.scale.y = 1


