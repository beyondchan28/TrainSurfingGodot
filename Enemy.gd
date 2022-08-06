extends RigidBody

export(float) var velocity
export(NodePath) onready var target_node_1 = get_node(target_node_1)

var current_pos: Vector3

func _ready():
	current_pos = target_node_1.get_global_transform().origin
	$NavigationAgent.set_target_location(current_pos)

func _physics_process(_delta):
	# Query the `NavigationAgent` to know the next free to reach location.
	var pos = get_global_transform().origin
	var target_pos = target_node_1.get_global_transform().origin
	update_location(pos, target_pos)


	# Calculate the velocity.


func update_location(self_pos, target_pos):
	if self_pos.distance_to(target_pos) != self_pos.distance_to(current_pos) :
		current_pos = target_pos
		$NavigationAgent.set_target_location(current_pos)
		var target = $NavigationAgent.get_next_location()
		var n = $RayCast.get_collision_normal()
		if n.length_squared() < 0.1:
			n = Vector3(0, 1, 0)

		var vel = (target - self_pos).slide(n).normalized() * velocity
		set_linear_velocity(vel)
		
