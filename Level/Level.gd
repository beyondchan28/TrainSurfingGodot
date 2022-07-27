extends Spatial

onready var player = $Player
onready var anim_cutscene = $AnimationPlayer

onready var telp_cutscene_trigger = $TelephonCutsceneTrigger
onready var telp_sound = $TelephoneSound

onready var flashlight = $FlashlightActivator

onready var park_light = $ParkLight
onready var street_light = $StreetLight

const next_scene = preload("res://Level/TrainStation.tscn")

var switch

func _ready():
	player.transform.translated(Vector3(-182.647, 1, 64.962))


func _on_TelephonCutsceneTrigger_body_entered(body):
	if body.name == "Player" and player.curr_state != player.STATES.CROUCH:
		player.transform.translated(Vector3(-25.067, 1, -27.481))
		telephone_cutscene()


func _on_TelephonCutsceneTrigger_body_exited(body):
	telp_cutscene_trigger.queue_free()

func telephone_cutscene():
	player.anim.stop(true)
	anim_cutscene.play("TelephonCutscene")
	yield(anim_cutscene, "animation_finished")
	player.set_physics_process(true)
	

func anim_started():
	player.set_physics_process(false)

func stop_sound():
	telp_sound.queue_free()
	

func _on_FlashlightActivator_body_entered(body):
	if body.name == "Player":
		player.get_node("Pivot/Armature/Skeleton/BoneAttachment").visible = true
		anim_cutscene.queue_free()
		flashlight.queue_free()


func _on_TranStationCutsceneTrigger_body_entered(body):
	if body.name == "Player":
		get_parent().add_child(next_scene.instance())
		self.queue_free()


func _on_LightActivator_body_entered(body):
	if body.name == "Player":
		if street_light.is_visible():
			park_light.set_visible(true)
		elif park_light.is_visible():
			street_light.set_visible(true)
