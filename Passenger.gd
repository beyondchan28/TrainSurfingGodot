extends Spatial

onready var anim = $AnimationPlayer
onready var detector = $Armature/BoneAttachment/WindowVision

onready var player = get_parent().get_parent().get_node("Player")

func _process(delta):
	if detector.is_connected("body_entered", detector, "attack"):
		anim.play("Idle")
	else:
		if !player.get_node("Pivot/Armature/Skeleton/WorkerJacket").is_visible():
			anim.play("Notice")
		return
