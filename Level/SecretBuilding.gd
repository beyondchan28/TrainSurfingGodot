extends Spatial

onready var clock = $Player/CanvasLayer/GamePlayUI/ClockBackground/Clock
var ending_vid = preload("res://UI/Ending.ogv")
onready var gameplay_ui = $Player/CanvasLayer

func _ready():
	clock.current_time = 5
	$Player/Pivot/Armature/Skeleton/BoneAttachment.set_visible(true)

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
	if entered.size() == 2:
		gameplay_ui.play_cutscene(ending_vid)
