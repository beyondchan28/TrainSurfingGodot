extends PathFollow


var speed = 2

func _process(delta):
	set_offset(get_offset() + speed * delta)
