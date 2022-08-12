extends RigidBody

export(float) var velocity
export(NodePath) onready var target_node_1 = get_node(target_node_1)
export(NodePath) onready var lost_target = get_node(lost_target).get_global_transform().origin


onready var graphic = $Graphic
onready var sign_text = $Sign
onready var timer = $Timer
onready var anim = $Graphic/AnimationPlayer

enum STATES {FOLLOW, STOP, LOST}

var current_state = STATES.LOST
var self_pos = Vector3.ZERO
var dist :float = 0

export(float) var min_dist = 25
export(bool) var activate = false

func _physics_process(_delta):
	var self_pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	dist = self_pos.distance_to(target_pos)
	if activate:
		if dist > 4.0 and dist <= min_dist:
			current_state = STATES.FOLLOW
		elif current_state != STATES.LOST and dist <= 4.0 or dist > min_dist:
			current_state = STATES.STOP
		if current_state == STATES.FOLLOW:
			update_location(self_pos, target_pos)
	elif current_state == STATES.LOST:
			update_location(self_pos, lost_target)
			if $NavigationAgent.is_target_reached():
				current_state = STATES.STOP
func update_location(self_pos, target_pos):
	graphic.look_at(target_pos, Vector3.UP)
	set_target_location(target_pos)
	var target = $NavigationAgent.get_next_location()
	var n = $RayCast.get_collision_normal()
	if n.length_squared() < 0.1:
		n = Vector3(0, 1, 0)
	var vel = (target - self_pos).slide(n).normalized() * velocity
	set_linear_velocity(vel)

func _process(delta):
	behaviour()
	if dist > 10 and current_state == STATES.STOP:
		sign_text.text = "!"
		sign_text.set_visible(true)
		$SpotLight.set_visible(false)
	elif activate or current_state != STATES.STOP:
		$SpotLight.set_visible(true)
		sign_text.set_visible(false)
	print(dist > 10)
func behaviour():
	if current_state == STATES.LOST:
		activate = false
		play_anim("Move")
		self.set_sleeping(false)
	elif current_state == STATES.FOLLOW:
		play_anim("Move")
		self.set_sleeping(false)
	elif current_state == STATES.STOP:
		play_anim("Idle")
		self.set_sleeping(true)
		timer.start()


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


func _on_SelfActivator_body_entered(body):
	if body.name == "Player":
		activate = true
