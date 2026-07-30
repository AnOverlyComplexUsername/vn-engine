extends Control

class_name VNCharacters

@export var character_name : StringName = &"ERROR"

func _ready() -> void:
	pass

#region Movement Code

##Moves character sprite to given global position in a given length of time in seconds
func move(globalPos : Control, lengthSeconds : float = 1) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position", globalPos.global_position, lengthSeconds)
	
	return tween.finished
	

##Places/teleports a character on a given global position
func place(globalPos : Control) -> void:
	self.global_position = globalPos.global_position
 
#endregion

func say(dialogue : String) -> Signal:
	DialogueBox.begin_dialogue_playback(dialogue, self.character_name)
	
	return DialogueBox.line_finished
	
func set_sprite() -> void:
	pass
