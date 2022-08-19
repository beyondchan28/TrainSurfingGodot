extends VideoPlayer

export(NodePath) onready var start_on = get_node(start_on) as TextureRect
export(NodePath) onready var start_off = get_node(start_off) as TextureRect

export(NodePath) onready var setting_on = get_node(setting_on) as TextureRect
export(NodePath) onready var setting_off = get_node(setting_off) as TextureRect

export(NodePath) onready var exit_on = get_node(exit_on) as TextureRect
export(NodePath) onready var exit_off = get_node(exit_off) as TextureRect

const first_scene = preload("res://Level/Level.tscn")
const loading_vid = preload("res://UI/loading-screen.webm")

var current_selection = 0

func _ready():
	set_current_selection(current_selection)

func _process(delta):
	if Input.is_action_just_pressed("move_backwards") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("move_forwards") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("jump"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		loading()
	elif _current_selection == 1:
		pass
		#about creator and the game
	elif _current_selection == 2:
		get_tree().quit()
		

func loading():
	self.set_stream(loading_vid)
	self.play()
	var children = self.get_children()
	children[0].set_visible(false)
	children[1].set_visible(false)
	children[2].set_visible(false)
	
	yield(self, "finished")
	get_parent().add_child(first_scene.instance())
	queue_free()

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
