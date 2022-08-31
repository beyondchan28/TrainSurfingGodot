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

onready var health_manager = $HealthManager
onready var flashlight = $Pivot/Armature/Skeleton/BoneAttachment

var flash_on = false

var climb_array = []

enum STATES{IDLE, JUMP, CROUCH, RUN, CLIMB, UNCLIMB}

var dead = false 

func _ready():
	collision_shape.get_shape().height = 3.5
	curr_state = STATES.IDLE
	health_manager.init()
	health_manager.connect("dead", self, "die")

func _physics_process(delta):
	var move_dir = 0
	var turn_dir = 0
	
	if dead:
		return
	
	if _runtime_data.current_gameplay_state == Enums.GameplayState.FREEWALK:
		movement_input(move_dir, turn_dir, delta)
		run()
		jump()
		crouch()
		climber_detection()
		flashlight()
	else:
		curr_state = STATES.IDLE
		move_dir = 0
		turn_dir = 0
		self.translation.y = 2
		anim.play("Idle")
	#print(curr_state)
	

func _process(delta):
	#for stable flashlight position
	if curr_state == STATES.IDLE:
		flashlight.rotation_degrees = Vector3(0.148, -90.118, -117.344)
	else:
		flashlight.rotation_degrees = Vector3(0.025, -90.187, -161.128)
		

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

	move_and_slide(move_vec, Vector3.UP, true)
	#print(move_vec)
	
	var was_grounded = grounded
	grounded = is_on_floor()
	climb_logic(move_vec)
	#animation idle, jump, walk, crouch, crouching and run here
	
	if curr_state == STATES.JUMP and not grounded and was_grounded:
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
	if is_on_floor() and Input.is_action_pressed("crouch"):
		curr_state = STATES.CROUCH
		move_speed = ms_changer
		collision_shape.get_shape().height = 1.75
	elif Input.is_action_just_released("crouch") :
		move_speed = 5
		collision_shape.get_shape().height = 3.5
		curr_state = STATES.IDLE

func run():
	var ms_changer = 10
	if is_on_floor() and Input.is_action_pressed("run") or curr_state == STATES.JUMP:
		curr_state = STATES.RUN
		move_speed = ms_changer
	elif !is_on_floor():
		move_speed = ms_changer
	else :
		curr_state = STATES.IDLE
		move_speed = 5

func flashlight():
	var light = flashlight.get_node("Flashlight/SpotLight")
	var objectives_detector = flashlight.get_node("Flashlight/ObejctivesArea/CollisionShape")
	
	if flashlight.is_visible():
		if Input.is_action_just_pressed("flashlight") and flash_on == false:
			flash_on = true
			objectives_detector.set_disabled(false)
			
			light.set_visible(true)
			#light.light_energy = 10
		elif Input.is_action_just_pressed("flashlight") and flash_on == true:
			flash_on = false
			objectives_detector.set_disabled(true)
			light.set_visible(false)
			
			#light.light_energy = 0


func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func get_aim_at_pos():
	return self.global_transform.origin + Vector3.UP * 1.9


func noticed(damage: int):
	health_manager.noticed()
	

func die():
	dead = true
	self.set_physics_process(false)

func _on_ObejctivesArea_area_entered(area):
	if area.name == "ObjectivesLightActivator":
		area.get_node("OmniLight").set_visible(true)


func _on_ObejctivesArea_area_exited(area):
	if area.name == "ObjectivesLightActivator":
		area.get_node("OmniLight").set_visible(false)
