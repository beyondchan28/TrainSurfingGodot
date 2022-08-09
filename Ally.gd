extends RigidBody

export(float) var velocity
export(NodePath) onready var target_node_1 = get_node(target_node_1)

onready var graphic = $Graphic
onready var sign_text = $Sign
onready var timer = $Timer

enum STATES {FOLLOW, STOP}

var current_state = STATES.STOP


func _physics_process(_delta):
	# Query the `NavigationAgent` to know the next free to reach location.
	var self_pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	
	if current_state == STATES.FOLLOW:
		self.set_sleeping(false)
		update_location(self_pos, target_pos)
	elif current_state == STATES.STOP:
		self.set_sleeping(true)
		return

func update_location(self_pos, target_pos):
	graphic.look_at(target_pos, Vector3.UP)
	set_target_location(target_pos)
	var target = $NavigationAgent.get_next_location()
	var n = $RayCast.get_collision_normal()
	if n.length_squared() < 0.1:
		n = Vector3(0, 1, 0)
	var vel = (target - self_pos).slide(n).normalized() * velocity
	set_linear_velocity(vel)

func _input(event):
	if Input.is_action_just_pressed("call") and current_state == STATES.FOLLOW:
		sign_text.text = "?"
		sign_text.set_visible(true)
		timer.start()
		current_state = STATES.STOP
		
	elif Input.is_action_just_pressed("call") and current_state == STATES.STOP:
		sign_text.text = "!"
		sign_text.set_visible(true)
		timer.start()
		current_state = STATES.FOLLOW

func set_target_location(pos):
	$NavigationAgent.set_target_location(pos)

func _on_Timer_timeout():
	sign_text.set_visible(false)

func _on_NavigationAgent_navigation_finished():
	pass

