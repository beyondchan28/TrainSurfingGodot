extends Spatial

export(Resource) var cutscene_vid = cutscene_vid

onready var player = $Player
onready var flashlight = $FlashlightActivator


#var telephone_vid = load("res://UI/RoomOfDepression15sec.webm")
#var next_level_vid = load("res://UI/RoomOfDepression15sec.webm")

onready var gameplay_ui = $Player/CanvasLayer
onready var hint = $Player/CanvasLayer/GamePlayUI/ObjectiveBackground/Hint

onready var clock = $Player/CanvasLayer/GamePlayUI/ClockBackground/Clock

func _ready():
	clock.current_time = 19

func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		hint.set_text("Pickup Friend in this area.")
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		flashlight.queue_free()

func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		hint.set_text("")
		gameplay_ui.play_cutscene(cutscene_vid.video[1])
		

func _on_TelephoneCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(cutscene_vid.video[0])
		hint.set_text("Go to The Park. Follow the Lights.")

func _on_TelephoneCutsceneTrigger_body_exited(body):
	if body.name == "Player":
		self.get_node("TelephoneCutsceneTrigger").queue_free()


func _on_FriendHintTrigger_body_entered(body):
	if body.name == "Player":
		hint.set_text("Go to the Train Station... Through fences...")
		self.get_node("FriendHintTrigger").queue_free()
		
