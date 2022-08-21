extends Control

export(NodePath) onready var eye_on1 = get_node(eye_on1) as TextureRect
export(NodePath) onready var eye_off1 = get_node(eye_off1) as TextureRect

export(NodePath) onready var eye_on2 = get_node(eye_on2) as TextureRect
export(NodePath) onready var eye_off2 = get_node(eye_off2) as TextureRect

export(NodePath) onready var eye_on3 = get_node(eye_on3) as TextureRect
export(NodePath) onready var eye_off3 = get_node(eye_off3) as TextureRect

onready var hint = $ObjectiveBackground/Hint
onready var current_level = get_parent().get_parent().get_parent()

var health = 0

func hint_display():
	pass

func update_health(amount):
	health = amount
	update_display()

func update_display():
	if health == 3:
		eye_on1.set_visible(true)
		eye_on2.set_visible(true)
		eye_on3.set_visible(true)
		
		eye_off1.set_visible(false)
		eye_off2.set_visible(false)
		eye_off3.set_visible(false)
	elif health == 2 :
		eye_on1.set_visible(true)
		eye_on2.set_visible(true)
		eye_on3.set_visible(false)
		
		eye_off1.set_visible(false)
		eye_off2.set_visible(false)
		eye_off3.set_visible(true)
	elif health == 1:
		eye_on1.set_visible(true)
		eye_on2.set_visible(false)
		eye_on3.set_visible(false)
		
		eye_off1.set_visible(false)
		eye_off2.set_visible(true)
		eye_off3.set_visible(true)
	elif health <= 0 :
		eye_on1.set_visible(false)
		eye_on2.set_visible(false)
		eye_on3.set_visible(false)
		
		eye_off1.set_visible(true)
		eye_off2.set_visible(true)
		eye_off3.set_visible(true)
