extends Spatial

onready var player = $Player
onready var flashlight = $FlashlightActivator

onready var park_light = $ParkLight
onready var street_light = $StreetLight
onready var other_objects = $OtherObjects

onready var canvas = $CanvasLayer

const next_scene = preload("res://Level/TrainStation.tscn")

export(Resource) var _runtime_data = _runtime_data as RuntimeData

func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		flashlight.queue_free()


func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		get_parent().add_child(next_scene.instance())
		self.queue_free()


func _on_TelephoneCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		_runtime_data.current_gameplay_state = Enums.GameplayState.IN_DIALOG
		canvas.get_node("VideoPlayer").set_visible(true)
		canvas.get_node("VideoPlayer").play()
		yield(canvas.get_node("VideoPlayer"), "finished")
		canvas.get_node("VideoPlayer").set_visible(false)
		_runtime_data.current_gameplay_state = Enums.GameplayState.FREEWALK

func _on_TelephoneCutsceneTrigger_body_exited(body):
		if body.name == "Player":
			self.get_node("TelephoneCutsceneTrigger").queue_free()
