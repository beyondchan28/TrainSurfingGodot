extends Label

var time = 0
var timer_on = true
var current_time = 4

export(NodePath) onready var health_manager = get_node(health_manager)

func _process(delta):
	if timer_on:
		time += delta
	
	var secs = fmod(time, 60)
	var mins = fmod((current_time +  fmod(time, 60*60) / 60), 24)
	
	var time_passed = "%02d:%02d" % [mins, secs]
	self.text = time_passed
	time_limit(mins)
	

func time_limit(mins):
	if health_manager.get_parent().get_parent().name == "Park" and fmod(mins, 1) <= 1.0:
		health_manager.emit_signal("dead")
	elif health_manager.get_parent().get_parent().name == "TrainStationLevel" and  fmod(mins, 5) <= 1.0:
		health_manager.emit_signal("dead")
	elif health_manager.get_parent().get_parent().name == "SecretBuilding" and  fmod(mins, 7) <= 1.0:
		health_manager.emit_signal("dead")
		
