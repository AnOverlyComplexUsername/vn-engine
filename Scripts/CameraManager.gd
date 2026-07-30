extends Camera2D

class_name CameraManager

func move_cam(globalPos : Control, lengthSeconds : float = 1) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position", globalPos.global_position, lengthSeconds)
	
	return tween.finished

##does a gradual zoom instead of a hard cut zoom 
func animate_zoom(magnification : float, lengthSeconds = 1) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "zoom", Vector2(magnification,magnification), lengthSeconds)

	return tween.finished

##Places/teleports a character on a given global position
func place_cam(globalPos : Control) -> void:
	self.global_position = globalPos.global_position
