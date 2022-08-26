extends CanvasLayer

export(Resource) var _runtime_data = _runtime_data as RuntimeData
export(Resource) var loading_vid = loading_vid as Cutscene
#export(Resource) var next_scene = next_scene as Scene
 
export(String, FILE, "*.tscn") var trainstation_scene
export(String, FILE, "*.tscn") var secretbuilding_scene



onready var gameplay_ui = $GamePlayUI
onready var video_player = $VideoPlayer

#var loading_vid = load("res://UI/loading-screen.webm")

var video_name: String

func _ready():
	if !self.is_inside_tree():
		self.set_visible(false)

func play_cutscene(video):
	_runtime_data.current_gameplay_state = Enums.GameplayState.IN_DIALOG
	video_player.set_stream(video)

	video_name = video.get_file()
	
	video_player.set_visible(true)
	gameplay_ui.set_visible(false)
	
	video_player.play()
	
	yield(video_player, "finished")
	
	gameplay_ui.set_visible(true)
	video_player.set_visible(false)
	_runtime_data.current_gameplay_state = Enums.GameplayState.FREEWALK


func next_level(next):
	get_tree().change_scene(next)

func _on_VideoPlayer_finished():
	if video_name == "res://UI/TrainStationCutscene.ogv":
		call_deferred("play_cutscene", loading_vid.video[0])
	elif self.get_parent().get_parent().name == "Level" and video_name == "res://UI/LoadingScreen.ogv":
		next_level(trainstation_scene)
	elif self.get_parent().get_parent().name == "TrainStationLevel" and video_name == "res://UI/LoadingScreen.ogv":
		next_level(secretbuilding_scene)
