extends Camera2D

##Controls camera movement in a scene/set

func _ready() -> void:
	set_to_center()

func move_to_center(lengthSeconds : float = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position",get_viewport_rect().size / 2, lengthSeconds).set_ease(_ease)
	
	return tween.finished
	
func move_cam(globalPos : Control, lengthSeconds : float = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position", globalPos.global_position, lengthSeconds).set_ease(_ease)
	
	return tween.finished

func animate_move_zoom_cam(globalPos : Control, magnification : float, lengthSeconds = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "zoom", Vector2(magnification,magnification), lengthSeconds).set_ease(_ease)
	tween.parallel().tween_property(self, "global_position", globalPos.global_position, lengthSeconds).set_ease(_ease)
	
	return tween.finished

##does a gradual zoom instead of a hard cut zoom 
func animate_zoom(magnification : float, lengthSeconds = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "zoom", Vector2(magnification,magnification), lengthSeconds).set_ease(_ease)

	return tween.finished

##Sets a zoom to a given magnification, does not animate the zoom
func set_zoom_level(magnification : float) -> void:
	self.zoom = Vector2(magnification,magnification)

##Sets position directly to center screen; no movement
func set_to_center() -> void:
	self.global_position = get_viewport_rect().size / 2


##Places/teleports a character on a given global position
func place_cam(globalPos : Control) -> void:
	self.global_position = globalPos.global_position
