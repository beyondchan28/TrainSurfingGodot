extends Spatial

onready var player = $Player
onready var enemy = $Navigation/Enemy
onready var reset_pos = $ResetPosition.get_global_transform().origin

export(NodePath) onready var enemy_1 = get_node(enemy_1)
export(NodePath) onready var enemy_2 = get_node(enemy_2)
export(NodePath) onready var enemy_3 = get_node(enemy_3)
export(NodePath) onready var enemy_4 = get_node(enemy_4)
export(NodePath) onready var enemy_5 = get_node(enemy_5)

var one_five = 0
var two_four = 0

#	enemy_1.set_physics_process(false); enemy_1.set_sleeping(true)
#	enemy_2.set_physics_process(false); enemy_2.set_sleeping(true)
#	enemy_3.set_physics_process(false); enemy_3.set_sleeping(true)
#	enemy_4.set_physics_process(false); enemy_4.set_sleeping(true)
#	enemy_5.set_physics_process(false); enemy_5.set_sleeping(true)

func _ready():
	enemy_3.current_state = enemy_3.STATES.PATROL_FWD
	pattern_one()


func _process(delta):
#	print(go_in)
	one_five = (enemy_1.reached() + enemy_5.reached())
	two_four = (enemy_2.reached() + enemy_4.reached())
	if one_five == 0 : 
		pattern_one()
	elif two_four == 2 : 
		pattern_two()
	print(two_four)
	

func pattern_one():
	enemy_1.current_state = enemy_1.STATES.STOP
	enemy_2.current_state = enemy_1.STATES.PATROL_FWD
	enemy_3.current_state = enemy_1.STATES.PATROL_FWD
	enemy_4.current_state = enemy_1.STATES.PATROL_FWD
	enemy_5.current_state = enemy_5.STATES.STOP

func pattern_two():
	if enemy_3.get_node("NavigationAgent").get_target_location() == enemy_3.patrol_2:
		enemy_1.current_state = enemy_1.STATES.PATROL_FWD
		enemy_2.current_state = enemy_2.STATES.STOP
		enemy_3.current_state = enemy_1.STATES.PATROL_FWD
		enemy_4.current_state = enemy_4.STATES.STOP
		enemy_5.current_state = enemy_5.STATES.PATROL_FWD


#func _on_DetectionArea_body_entered(body):
#	if body.name == "Enemy3":
#		go_in += 1
#
#func _on_DetectionArea_body_exited(body):
#	if body.name == "Enemy3":
#		go_out += 1
