extends Control

class_name VNCharacters

##Name of character
@export var character_name : StringName = &"ERROR"

@onready var sprite: Sprite2D = $sprite

##a dictionary of sprites to their names
@export var expressions : Dictionary[StringName, Texture]

##A talk sound effect that plays every letter of spoken dialogue
@export var talkSFX : AudioStream


#region Movement Code

##Moves [VNCharacters] to given control node's global positions in [param lengthSeconds] using tweens [br]
##you can pas a custom tween into [param _tween] if you want custom ease and transition type
func move(globalPos : Control, lengthSeconds : float = 1,  _tween : Tween = null) -> Signal:
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(self, "global_position", globalPos.global_position, lengthSeconds) 
	
	return tween.finished
	

##Places/teleports [VNCharacters] on a given control node's global position
func place(globalPos : Control) -> void:
	self.global_position = globalPos.global_position
 
#endregion

##calls the DialogueBox to display given dialogue [br]
##use [param letter_delay] to specify the delay between when each letter is displayed in dialogue [br]
##if character has a set sfx for talking, use [param use_talk_sfx] to enable/disable its usage
func say(dialogue : String, use_talk_sfx : bool = true, letter_delay : float = Global.letter_delay) -> Signal:
	if use_talk_sfx and talkSFX: DialogueBox.begin_dialogue_playback(dialogue, self.character_name ,talkSFX,letter_delay)
	else: DialogueBox.begin_dialogue_playback(dialogue, self.character_name,null,letter_delay)
	
	return DialogueBox.line_finished

##Given a string [param expression_name], [br]
##change the character's expression if it exists within [member expressions]
func set_expression(expression_name : String) -> void:
	var expression : StringName = StringName(expression_name)
	if expressions.has(expression):
		sprite.texture = expressions[expression]

#region Sprite transitions
func fade_out(lengthSeconds : float = 1,  _tween : Tween = null) -> Signal:
	self.modulate.a = 1
	self.show()
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 0, lengthSeconds) 
	
	return tween.finished

func fade_in(lengthSeconds : float = 1,  _tween : Tween = null) -> Signal:
	self.modulate.a = 0
	self.show()
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 1, lengthSeconds) 
	
	return tween.finished
#endregion
