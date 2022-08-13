extends Spatial

signal dead
signal noticed
signal health_changed

export var max_health = 3
var current_health = 1

func _ready():
	init()

func init():
	current_health = max_health
	emit_signal("health_changed", current_health)


func noticed(damage: int = 1):
	if current_health <= 0:
		return
	current_health -= damage
	if current_health <= 0:
		emit_signal("dead")
	else:
		emit_signal("noticed")
	emit_signal("health_changed", current_health)
	print(current_health)
	
