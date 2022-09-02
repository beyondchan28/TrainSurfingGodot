extends Spatial

onready var clock = $Player/CanvasLayer/GamePlayUI/ClockBackground/Clock
var ending_vid = preload("res://UI/Ending.ogv")
onready var gameplay_ui = $Player/CanvasLayer
onready var hint = $Player/CanvasLayer/GamePlayUI/ObjectiveBackground/Hint

func _ready():
	set_hint("Crossing without noticed")
	clock.current_time = 5
	$Player/Pivot/Armature/Skeleton/BoneAttachment.set_visible(true)

func set_hint(text: String):
	hint.set_text(text)
	hint.get_node("HintSound").play()

func _on_OnArea_area_entered(area):
	if area.name == "RobotArea":
		area.get_parent().get_node("Armature/Skeleton/BoneAttachment").set_visible(true)
		
		area.get_parent().get_node("PlayerDetector").set_visible(false)
		area.get_parent().get_node("PlayerDetector").set_monitoring(false)

func _on_OffArea_area_entered(area):
		if area.name == "RobotArea":
			area.get_parent().get_node("Armature/Skeleton/BoneAttachment").set_visible(false)
			
			area.get_parent().get_node("PlayerDetector").set_visible(true)
			area.get_parent().get_node("PlayerDetector").set_monitoring(true)


func _on_RewardArea_body_entered(body):
	var entered = $RewardArea.get_overlapping_bodies()
	print(entered)
	if entered.size() == 2:
		$Robot.queue_free()
		gameplay_ui.play_cutscene(ending_vid)
