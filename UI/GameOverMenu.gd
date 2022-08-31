extends Control

var is_paused = false setget set_is_paused
var current_selection = 0

export(NodePath) onready var restart_on = get_node(restart_on)
export(NodePath) onready var restart_off = get_node(restart_off)

export(NodePath) onready var backmain_on = get_node(backmain_on)
export(NodePath) onready var backmain_off = get_node(backmain_off)

export(NodePath) onready var exit_on = get_node(exit_on)
export(NodePath) onready var exit_off = get_node(exit_off)

var can_use = false

func _ready():
	set_current_selection(current_selection)

#func _process(delta):
#	print(current_selection)

func _unhandled_input(event):
	if get_tree().is_paused() and can_use:
		if Input.is_action_pressed("move_backwards") and current_selection < 2:
			current_selection += 1
			set_current_selection(current_selection)
		elif Input.is_action_pressed("move_forwards") and current_selection > 0:
			current_selection -= 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("next_dialog"):
			handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().reload_current_scene()
		get_tree().set_pause(false)
	elif _current_selection == 1:
		get_tree().change_scene("res://UI/MainMenu.tscn")
		print("dafaq")
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection) :
	restart_off.visible = true
	restart_on.visible = false
	
	backmain_off.visible = true
	backmain_on.visible = false
	
	exit_off.visible = true
	exit_on.visible = false
	
	if _current_selection == 0:
		restart_off.visible = false
		restart_on.visible = true
	elif _current_selection == 1:
		backmain_off.visible = false
		backmain_on.visible = true
	elif _current_selection == 2:
		exit_off.visible = false
		exit_on.visible = true

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func when_die():
	can_use = true
	set_visible(true)
	set_is_paused(!is_paused)
