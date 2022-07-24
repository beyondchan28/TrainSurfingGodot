extends Spatial

onready var vision_manager = $VisionManager

var target

func _ready():
	target = get_parent().get_node("Player")
func _process(delta):
	var target_point = target.global_transform.origin + Vector3.UP
	if target.has_method("get_aim_at_pos"):
		target_point = target.get_aim_at_pos()
	if vision_manager.in_vision(target_point) and vision_manager.has_line_of_sight(target_point):
		$Red.show()
		$Yellow.hide()
	else:
		$Red.hide()
		$Yellow.show()
