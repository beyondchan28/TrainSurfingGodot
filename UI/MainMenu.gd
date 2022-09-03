extends VideoPlayer

export(NodePath) onready var start_on = get_node(start_on) as TextureRect
export(NodePath) onready var start_off = get_node(start_off) as TextureRect

export(NodePath) onready var howtoplay_on = get_node(howtoplay_on) as TextureRect
export(NodePath) onready var howtoplay_off = get_node(howtoplay_off) as TextureRect

export(NodePath) onready var exit_on = get_node(exit_on) as TextureRect
export(NodePath) onready var exit_off = get_node(exit_off) as TextureRect

const loading_vid = preload("res://UI/LoadingScreen.ogv")

var current_selection = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_current_selection(current_selection)
	get_tree().set_pause(false)

func _unhandled_input(event):
	if Input.is_action_just_pressed("move_backwards") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("move_forwards") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("next_dialog"):
		handle_selection(current_selection)
	
	#for testing only
	if Input.is_action_just_pressed("level_1"):
		get_tree().change_scene("res://Level/Level.tscn")
	elif Input.is_action_just_pressed("level_2"):
		get_tree().change_scene("res://Level/TrainStationLevel.tscn")
	elif Input.is_action_just_pressed("level_3"):
		get_tree().change_scene("res://Level/SecretBuilding.tscn")
	
	if !current_selection == 1:
		self.get_node("HowtoplayControl").set_visible(false)

func handle_selection(_current_selection):
	if _current_selection == 0:
		loading()
	elif _current_selection == 1:
		self.get_node("HowtoplayControl").set_visible(true)
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
	get_tree().change_scene("res://Level/Level.tscn")

func set_current_selection(_current_selection) :
	start_off.visible = true
	start_on.visible = false
	
	howtoplay_off.visible = true
	howtoplay_on.visible = false
	
	exit_off.visible = true
	exit_on.visible = false
	
	if _current_selection == 0:
		start_off.visible = false
		start_on.visible = true
	elif _current_selection == 1:
		howtoplay_off.visible = false
		howtoplay_on.visible = true
	elif _current_selection == 2:
		exit_off.visible = false
		exit_on.visible = true


func _on_MainMenuVideo_finished():
	self.play()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
