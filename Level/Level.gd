extends Spatial


onready var player = $Player
onready var anim_cutscene = $AnimationPlayer
onready var telp_cutscene_trigger = $TelephonCutsceneTrigger
onready var telp_sound = $TelephoneSound
onready var pickup_telp_sound = $PickupPhoneSound


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
	
	

