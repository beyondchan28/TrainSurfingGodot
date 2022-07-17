extends Spatial


onready var player = $Player
onready var anim_cutscene = $Player/Pivot/AnimationPlayer
export(NodePath) onready var telephone = get_node(telephone) as MeshInstance 

func _ready():
	player.transform.translated(Vector3(-25.067, 0, -27.481))


func _on_Area_body_entered(body):
	if body.name == "Player":
		telephone_cutscene()


func telephone_cutscene():
	player.anim.stop()
	anim_cutscene.play("TelephonCutscene")
	yield(anim_cutscene, "animation_finished")
