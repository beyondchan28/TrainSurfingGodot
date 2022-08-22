extends Control

export(NodePath) onready var _dialog_text = get_node(_dialog_text) as Label
export(NodePath) onready var _avatar = get_node(_avatar) as TextureRect
var _current_dialogue: Dialogue

export(Resource) var _runtime_data = _runtime_data as RuntimeData

var _current_slides_index := 0

func _ready():
	GameEvents.connect("dialog_initiated", self, "_on_dialog_initiated")
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")

func _input(event):
	if _current_dialogue != null:
		if Input.is_action_just_pressed("next_dialog"):
			if _current_slides_index < _current_dialogue.dialog_slides.size() - 1:
				_current_slides_index += 1
				show_slide()
			else:
				GameEvents.emit_signal("dialog_finished")

func show_slide():
	_dialog_text.text = _current_dialogue.dialog_slides[_current_slides_index]

func _on_dialog_initiated(dialogue: Dialogue):
	_runtime_data.current_gameplay_state = Enums.GameplayState.IN_DIALOG
	_current_dialogue = dialogue
	_current_slides_index = 0
	_avatar.texture = dialogue.avatar_texture
	show_slide()
	self.visible = true
	
func _on_dialog_finished():
	_runtime_data.current_gameplay_state = Enums.GameplayState.FREEWALK
	self.visible = false
