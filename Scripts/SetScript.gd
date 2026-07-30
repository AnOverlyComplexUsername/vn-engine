extends Control

##Class for scripting VN scene & controlling what characters there are 
class_name SetScript

signal set_ended

##creates a delay
func wait(durationSeconds : float) -> Signal:
	var clock := get_tree().create_timer(durationSeconds,true,true)
	
	return clock.timeout

##called at the end of a set/scene
func end_set() -> Signal:
	return set_ended
