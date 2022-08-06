extends VideoPlayer

export(NodePath) onready var start_on = get_node(start_on) as TextureRect
export(NodePath) onready var start_off = get_node(start_off) as TextureRect

export(NodePath) onready var setting_on = get_node(setting_on) as TextureRect
export(NodePath) onready var setting_off = get_node(setting_off) as TextureRect

export(NodePath) onready var exit_on = get_node(exit_on) as TextureRect
export(NodePath) onready var exit_off = get_node(exit_off) as TextureRect



const first_scene = preload("res://Level/Level.tscn")

var current_selection = 0

func _ready():
	set_current_selection(current_selection)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_parent().add_child(first_scene.instance())
		queue_free()
	elif _current_selection == 1:
		pass
		#about creator and the game
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection) :
	start_off.visible = true
	start_on.visible = false
	
	setting_off.visible = true
	setting_on.visible = false
	
	exit_off.visible = true
	exit_on.visible = false
	
	if _current_selection == 0:
		start_off.visible = false
		start_on.visible = true
	elif _current_selection == 1:
		setting_off.visible = false
		setting_on.visible = true
	elif _current_selection == 2:
		exit_off.visible = false
		exit_on.visible = true


func _on_MainMenuVideo_finished():
	self.play()
