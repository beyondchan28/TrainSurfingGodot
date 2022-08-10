extends RigidBody

export(float) var velocity
export(NodePath) onready var target_node_1 = get_node(target_node_1)

onready var graphic = $Graphic
onready var sign_text = $Sign
onready var timer = $Timer
onready var anim = $Graphic/AnimationPlayer

enum STATES {FOLLOW, STOP}

var current_state = STATES.STOP
var can_call = false

export(bool) var activate = false

func _physics_process(_delta):
	# Query the `NavigationAgent` to know the next free to reach location.
	var self_pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	var dist = self_pos.distance_to(target_pos)
	if dist <= 25:
		can_call = true
	elif dist > 25:
		can_call = false
		current_state = STATES.STOP
	if current_state == STATES.FOLLOW:
		update_location(self_pos, target_pos)
	behaviour()

func update_location(self_pos, target_pos):
	graphic.look_at(target_pos, Vector3.UP)
	set_target_location(target_pos)
	var target = $NavigationAgent.get_next_location()
	var n = $RayCast.get_collision_normal()
	if n.length_squared() < 0.1:
		n = Vector3(0, 1, 0)
	var vel = (target - self_pos).slide(n).normalized() * velocity
	set_linear_velocity(vel)

func behaviour():
	if current_state == STATES.FOLLOW:
		play_anim("Move")
		self.set_sleeping(false)
	elif current_state == STATES.STOP:
		play_anim("Idle")
		self.set_sleeping(true)


func _input(event):
	if activate:
		if can_call:
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

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func _on_Timer_timeout():
	sign_text.set_visible(false)

func _on_SelfActivatorArea_body_entered(body):
	if body.name == "Player":
		activate = true


func _on_NavigationAgent_velocity_computed(safe_velocity):
	self.set_linear_velocity(safe_velocity)


func _on_NavigationAgent_navigation_finished():
	pass # Replace with function body.
