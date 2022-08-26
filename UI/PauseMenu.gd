extends Control

var is_paused = false setget set_is_paused
var current_selection = 0

export(NodePath) onready var resume_on = get_node(resume_on)
export(NodePath) onready var resume_off = get_node(resume_off)

export(NodePath) onready var restart_on = get_node(restart_on)
export(NodePath) onready var restart_off = get_node(restart_off)

export(NodePath) onready var exit_on = get_node(exit_on)
export(NodePath) onready var exit_off = get_node(exit_off)

var can_toggle = true

func _ready():
	set_current_selection(current_selection)

func _unhandled_input(event):
	if event.is_action_pressed("pause") and can_toggle:
		self.is_paused = !is_paused
	if get_tree().is_paused():
		if Input.is_action_pressed("move_backwards") and current_selection < 2:
			if can_toggle:
				current_selection += 1
			else:
				current_selection = 2
			set_current_selection(current_selection)
		elif Input.is_action_pressed("move_forwards") and current_selection > 0:
			if can_toggle:
				current_selection -= 1
			else:
				current_selection = 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("next_dialog"):
			handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		self.is_paused = false
	elif _current_selection == 1:
		get_tree().reload_current_scene()
		get_tree().set_pause(false)
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection) :
	resume_off.visible = true
	resume_on.visible = false
	
	restart_off.visible = true
	restart_on.visible = false
	
	exit_off.visible = true
	exit_on.visible = false
	
	if _current_selection == 0:
		resume_off.visible = false
		resume_on.visible = true
	elif _current_selection == 1:
		restart_off.visible = false
		restart_on.visible = true
	elif _current_selection == 2:
		exit_off.visible = false
		exit_on.visible = true

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func when_die():
	get_node("Background/CenterContainer/VBoxContainer/HBoxContainer").set_visible(false)
	get_node("Background/CenterContainer/Title").set_text("You Are Noticed !")
	current_selection = 1
	set_current_selection(current_selection)
	can_toggle = false
	set_is_paused(!is_paused)
