extends Spatial

onready var player = $Player
onready var flashlight = $FlashlightActivator

onready var loading_screen = $CanvasLayer/LoadingScreen

const telephone_vid = preload("res://UI/RoomOfDepression15sec.webm")
const next_level_vid = preload("res://UI/RoomOfDepression15sec.webm")

onready var gameplay_ui = $CanvasLayer

func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		flashlight.queue_free()

func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(next_level_vid)

func _on_TelephoneCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(telephone_vid)

func _on_TelephoneCutsceneTrigger_body_exited(body):
		if body.name == "Player":
			self.get_node("TelephoneCutsceneTrigger").queue_free()
