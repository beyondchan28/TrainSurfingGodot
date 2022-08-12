extends Spatial



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
