extends Spatial

var got_key_access = false
onready var gameplay_ui = $Player/CanvasLayer

var loading_vid = preload("res://UI/LoadingScreen.ogv")
#var next_level = load("res://Level/SecretBuilding.tscn")


onready var clock = $Player/CanvasLayer/GamePlayUI/ClockBackground/Clock

onready var hint = $Player/CanvasLayer/GamePlayUI/ObjectiveBackground/Hint

func _ready():
	clock.current_time = 1
	set_hint("Find Jacket Worker")
	$Player/Pivot/Armature/Skeleton/BoneAttachment.set_visible(true)
	

func set_hint(text: String):
	hint.set_text(text)
	hint.get_node("HintSound").play()

func play_sound():
	$CollectSound.play()
	$Player/Pivot/Armature/Skeleton/BoneAttachment.set_visible(true)

func _on_JacketTrigger_body_entered(body):
	if body.name == "Player":
		play_sound()
		set_hint("Find and take Key Access")
		body.get_node("Pivot/Armature/Skeleton/Body").set_visible(false)
		body.get_node("Pivot/Armature/Skeleton/WorkerJacket").set_visible(true)
		$JacketTrigger.queue_free()
		

func _on_KeyAccess_body_entered(body):
	if body.name == "Player" and !$JacketTrigger.is_inside_tree():
		set_hint("Meet \"Friend\"")
		got_key_access = true
		$KeyAccess.queue_free()


func _on_EndPoint_body_entered(body):
	if body.name == "Player" and got_key_access == true:
		
		play_sound()
		gameplay_ui.play_cutscene(loading_vid)
