extends Control

class_name VNCharacters

##Name of character
@export var character_name : StringName = &"ERROR"

##A talk sound effect that plays every letter of spoken dialogue
@export var talkSFX : AudioStream

func _ready() -> void:
	pass

#region Movement Code

##Moves character sprite to given global position in a given length of time in seconds
func move(globalPos : Control, lengthSeconds : float = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position", globalPos.global_position, lengthSeconds).set_ease(_ease)
	
	return tween.finished
	

##Places/teleports a character on a given global position
func place(globalPos : Control) -> void:
	self.global_position = globalPos.global_position
 
#endregion

func say(dialogue : String, use_talk_sfx : bool = true) -> Signal:
	if use_talk_sfx and talkSFX: DialogueBox.begin_dialogue_playback(dialogue, self.character_name ,talkSFX)
	else: DialogueBox.begin_dialogue_playback(dialogue, self.character_name)
	
	return DialogueBox.line_finished

func set_sprite() -> void:
	pass
