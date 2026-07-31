extends Control

##Class for scripting VN scene & controlling what characters there are 
class_name SetScript

signal set_ended

func _enter_tree() -> void:
	DialogueBox.skip_scene.connect(end_set)

##creates a delay
func wait(durationSeconds : float) -> Signal:
	var clock := get_tree().create_timer(durationSeconds,true,true)
	
	return clock.timeout

##called at the end of a set/scene
func end_set() -> Signal:
	print('skipping')
	return set_ended
