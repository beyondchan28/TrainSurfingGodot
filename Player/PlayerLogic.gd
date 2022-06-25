extends KinematicBody

const MOVE_SPEED = 5
const TURN_SPEED = 180
const GRAVITY = 98
const MAX_FALL_SPEED = 30
 
var y_velo = 0
var grounded = false
 
func _physics_process(delta):
	var move_dir = 0
	var turn_dir = 0
	if Input.is_action_pressed("move_forwards"):
		move_dir -= 1
	if Input.is_action_pressed("move_backwards"):
		move_dir += 1
	if Input.is_action_pressed("turn_right"):
		turn_dir -= 1
	if Input.is_action_pressed("turn_left"):
		turn_dir += 1
 
	rotation_degrees.y += turn_dir * TURN_SPEED * delta
	var move_vec = global_transform.basis.z * MOVE_SPEED * move_dir
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0, 1, 0))
 
	var was_grounded = grounded
	grounded = is_on_floor()
	y_velo -= GRAVITY * delta
	if grounded:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
 
	if not grounded and was_grounded:
		pass
	if grounded:
		if move_vec.x == 0 and move_vec.z == 0:
			pass
		else:
			pass
