extends Spatial

onready var anim = $AnimationPlayer
onready var detector = $Armature/BoneAttachment/WindowVision

func _process(delta):
	if detector.is_connected("body_entered", detector, "attack"):
		anim.play("Idle")
	else:
		anim.play("Notice")
