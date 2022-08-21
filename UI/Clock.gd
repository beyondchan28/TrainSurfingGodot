extends Label

var time = 3655
var timer_on = true
var current_time = 22



func _process(delta):
	if timer_on:
		time += delta
	
	var secs = fmod(time, 60)
	var mins = fmod((current_time +  fmod(time, 60*60) / 60), 24)
	
	var time_passed = "%02d:%02d" % [mins, secs]
	self.text = time_passed
