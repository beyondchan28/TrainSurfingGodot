extends CanvasLayer

export(Resource) var _runtime_data = _runtime_data as RuntimeData

onready var gameplay_ui = $GamePlayUI
onready var video_player = $VideoPlayer

const loading_vid = preload("res://UI/loading-screen.webm")

var video_name: String
var play_loading:bool = false 

func _process(delta):
	if play_loading:
		play_cutscene(loading_vid)

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


func _on_VideoPlayer_finished():
	if video_name == "res://UI/RoomOfDepression15sec.webm":
		play_loading = true
