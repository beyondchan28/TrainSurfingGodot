extends Spatial


onready var player = $Player
onready var anim_cutscene = $AnimationPlayer
export(NodePath) onready var telephone = get_node(telephone) as MeshInstance 

func _ready():
	player.transform.translated(Vector3(-182.647, 1, 64.962))


func _on_Area_body_entered(body):
	if body.name == "Player" and player.curr_state != player.STATES.CROUCH:
		player.transform.translated(Vector3(-25.067, 1, -27.481))
		telephone_cutscene()


func telephone_cutscene():
	player.anim.stop(true)
	anim_cutscene.play("TelephonCutscene")
	yield(anim_cutscene, "animation_finished")
	player.set_physics_process(true)
	

func anim_started():
	player.set_physics_process(false)

func anim_finished():
	pass
