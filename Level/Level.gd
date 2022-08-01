extends Spatial

onready var player = $Player
onready var flashlight = $FlashlightActivator

onready var park_light = $ParkLight
onready var street_light = $StreetLight
onready var other_objects = $OtherObjects

const next_scene = preload("res://Level/TrainStation.tscn")


func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		flashlight.queue_free()


func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		get_parent().add_child(next_scene.instance())
		self.queue_free()


func _on_LightActivator_body_entered(body):
	if body.name == "Player":
		if street_light.is_visible():
			park_light.set_visible(true)
			other_objects.set_visible(false)
		elif park_light.is_visible():
			street_light.set_visible(true)
			other_objects.set_visible(true)
