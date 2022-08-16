extends Spatial

onready var vision_manager = $VisionManager
onready var lampu_sorot = get_parent().get_node("LampuSorot/Cube002/SpotLight")

export var min_distance:float = 60

signal detected

var target

var damage = 1

func _ready():
	target = get_parent().get_node("Player")
	self.connect("detected", self, "attack", [], 4)
	
func _process(delta):
	var target_point = target.global_transform.origin + Vector3.UP
	var self_point = self.global_transform.origin
	var distance = self_point.distance_to(target_point)
#	print(distance)
	if target.has_method("get_aim_at_pos"):
		target_point = target.get_aim_at_pos()
	if distance <= min_distance and vision_manager.in_vision(target_point) and vision_manager.has_line_of_sight(target_point):
		$Red.show()
		$Yellow.hide()
		emit_signal("detected")
		print(distance)
		print(self.name)
	else:
		$Red.hide()
		$Yellow.show()
		if !self.is_connected("detected", self, "attack"):
			self.connect("detected", self, "attack", [], 4)
		

func attack():
	if !target.get_node("Pivot/Armature/Skeleton/WorkerJacket").is_visible():
		target.noticed(damage)
	else:
		return
