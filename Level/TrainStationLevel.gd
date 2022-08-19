extends Spatial

var got_key_access = true
onready var gameplay_ui = $CanvasLayer

var loading_vid = preload("res://UI/loading-screen.webm")
#var next_level = load("res://Level/SecretBuilding.tscn")

func _on_JacketTrigger_body_entered(body):
	if body.name == "Player":
		body.get_node("Pivot/Armature/Skeleton/Body").set_visible(false)
		body.get_node("Pivot/Armature/Skeleton/WorkerJacket").set_visible(true)
		$JacketTrigger.queue_free()
		

func _on_KeyAccess_body_entered(body):
	if body.name == "Player":
		got_key_access = true
		$KeyAccess.queue_free()


func _on_EndPoint_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(loading_vid)
