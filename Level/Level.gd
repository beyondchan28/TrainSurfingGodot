extends Spatial

export(Resource) var cutscene_vid = cutscene_vid as Cutscene

onready var player = $Player
onready var flashlight = $FlashlightActivator


#var telephone_vid = load("res://UI/RoomOfDepression15sec.webm")
#var next_level_vid = load("res://UI/RoomOfDepression15sec.webm")


onready var gameplay_ui = $CanvasLayer

func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		flashlight.queue_free()

func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(cutscene_vid.video[1])

func _on_TelephoneCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		gameplay_ui.play_cutscene(cutscene_vid.video[0])

func _on_TelephoneCutsceneTrigger_body_exited(body):
		if body.name == "Player":
			self.get_node("TelephoneCutsceneTrigger").queue_free()
