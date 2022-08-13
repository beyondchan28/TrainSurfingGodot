extends Area

onready var player = get_parent().get_parent().get_node("Player")

var damage = 1 

func _ready():
	connecting()

func connecting():
	connect("body_entered", self, "attack", [], 4)
	

func attack(body):
	if body.name == "Player":
		body.noticed(damage)

func emmiting():
	emit_signal("body_entered")

func on():
	$VisualArea.set_visible(true)
	self.set_monitoring(true)

func off():
	$VisualArea.set_visible(false)
	self.set_monitoring(false)

func _on_WindowVision_body_exited(body):
	if body.name == "Player":
		connecting()
