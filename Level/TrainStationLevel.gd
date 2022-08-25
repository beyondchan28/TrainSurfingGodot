extends Spatial

var got_key_access = false
onready var gameplay_ui = $Player/CanvasLayer

var loading_vid = preload("res://UI/LoadingScreen.ogv")
#var next_level = load("res://Level/SecretBuilding.tscn")

onready var clock = $Player/CanvasLayer/GamePlayUI/ClockBackground/Clock

func _ready():
	clock.current_time = 1

func play_sound(audio):
	$CollectSound.set_stream(audio)
	$CollectSound.play()

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
	if body.name == "Player" and got_key_access == true:
		gameplay_ui.play_cutscene(loading_vid)
