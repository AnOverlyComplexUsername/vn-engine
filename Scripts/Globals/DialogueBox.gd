extends Control

@export var _text_area: RichTextLabel
@export var _name_label: Label
@export var _text_sfx: AudioStreamPlayer
@export var _speed_button: Button
@export var _auto_button: Button
@export var _hide_button: Button
@export var _voice_line: AudioStreamPlayer
@export var _choice_container: VBoxContainer
@export var _skip_button: Button
@export var _history_button: Button
@export var _history_v_box: VBoxContainer

@export var _history: Control 
@export var _history_close_button: Button 

##Serves as a parent node to dialogue_box UI 
@export var _container: Control

##Called to replay voice lines from the history panel
@export var _replayed_voice_line: AudioStreamPlayer

##speed of dialogue playback
var speedScale : int = 1 

##Determines if dialogue box should auto progress upon line completion 
##or require manual player input
var auto_mode : bool = false

var _currentChoices : Array[ChoiceButton]

##Enitted when a dialogue line is finished playing
signal line_finished

##Emitted when player picks a dialogue choice and emits the id of the choice chosen
signal choice_picked(id : String)

##Emitted when player presses [member _skip_button] 
signal skip_scene 

#region Default Functions
func _enter_tree() -> void:
	_speed_button.pressed.connect(next_switch_speed)
	_auto_button.pressed.connect(toggle_auto)
	_hide_button.pressed.connect(hide_dialogue_ui)
	_skip_button.pressed.connect(skip_scene.emit)
	_history_button.pressed.connect(_open_history_menu)
	_history_close_button.pressed.connect(_close_history_menu)
	_voice_line.finished.connect(_reset_voice_line_player)
	choice_picked.connect(_new_choice_history_box)
	

func _input(event: InputEvent) -> void:
	##Shows dialogue UI if hidden 
	if event.is_action_pressed("ui_cancel") and _container.visible == false:
		_container.show()
		switch_playback_speed(speedScale)
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and _text_area.text != "" and _container.visible:
		##If text not done playing; fully complete
		if _text_area.visible_characters != -1: _text_area.visible_characters = -1
		
		##If text done playing, emit finished
		elif _text_area.visible_characters == -1: _check_choices()

#endregion


#region Setters

func set_name_label(char_name : StringName) -> void:
	_name_label.text = char_name

func set_text(line : String) -> void:
	_text_area.text = line
	
#endregion


#region Button Functionality
##toggles auto mode or not; [br]
##auto mode will automatically go to the next input after dialogue is played back
func toggle_auto() -> void:
	auto_mode = _auto_button.button_pressed

func hide_dialogue_ui() -> void:
	switch_playback_speed(0)
	_container.hide()

##moves switch speed to next increment
func next_switch_speed() -> void:
	speedScale = wrapi(speedScale + 1,1,4)
	switch_playback_speed(speedScale)
	_speed_button.text =  "%sx speed" % speedScale

##Switches playback speed to next setting
func switch_playback_speed(speed : int) -> void:
	Engine.time_scale = speed
#endregion


#region Text Area playback
##plays text displaying animation 
func _play_text(letter_delay : float = Global.letter_delay) -> void:
	##Base case; if text fully visible, return
	if _text_area.visible_ratio >= 1.0:
		_text_area.visible_characters = -1 
		if auto_mode: _check_choices()
		elif not _currentChoices.is_empty(): _choice_container.show()
		return
	else:
		_text_area.visible_characters += 1
		if _text_sfx and _text_sfx.stream: _text_sfx.play()
		await get_tree().create_timer(letter_delay,true,true).timeout
		_play_text(letter_delay)

##Displays and plays dialogue animation 
func begin_dialogue_playback(dialogue : String, char_name : StringName, sfx : AudioStream = null, letter_delay : float = Global.letter_delay) -> void:
	set_text(dialogue)
	set_name_label(char_name)
	##Hardcoded to avoid voice lines carrying over when creating new history entries 
	if _voice_line.get_playback_position() >= 0.01: _reset_voice_line_player()
	if sfx: _text_sfx.stream = sfx
	else: _text_sfx.stream = null
		
	_text_area.visible_ratio = -1
	
	if not _container.visible:
		await fade_in()

	_new_history_box()
	_play_text(letter_delay)

##Checks if there are choices at the end of a sentence
func _check_choices() -> void:
	if _currentChoices.is_empty():
		line_finished.emit()
	else: _choice_container.show()
#endregion


#region Choices System
##Pass [param choices] that will be displayed at the end of the next sentence [br]
##[param choices] is an array of strings [br]
##[br]
## Usage:
## [codeblock]
##DialogueBox.set_choices("hi", "bye")
##t.say("Hello")
##	
##var answer : String = await DialogueBox.choice_picked
##	
##if answer == "hi": print("first option")
##		
##elif answer == "bye": print("second option")
## [/codeblock]
func set_choices(...choices : Array) -> void:
	##reset choices for next set of choices
	_currentChoices = []
	
	for choice in choices:
		assert(choice is String) ##validate input
		var newButton : ChoiceButton = ChoiceButton.new(choice)
		_currentChoices.append(newButton)
		newButton.choice_id.connect(_chosen_choice)
		_choice_container.add_child(newButton)

##Set a dictionary [param choices] that will be displayed at the end of the next sentence [br]
##When creating the choice buttons it will use the key for button text 
##and emit value in [signal choice_picked] [br]
##[br]
##Usage:
## [codeblock]
##var choices : Dictionary[String,String] = {
##			"hi": "first_option", 
##			"bye" : "second_option"
##		}
##t.say("Hello")
##	
##var answer : String = await DialogueBox.choice_picked
##	
##if answer == "first_option": print("first option")
##		
##elif answer == "second_option": print("second option")
## [/codeblock]
func set_secret_choices(choices : Dictionary[String,String]) -> void:
	##reset choices for next set of choices
	_currentChoices = []
	
	for choice in choices:
		var newButton : ChoiceButton = ChoiceButton.new(choices[choice],choice)
		_currentChoices.append(newButton)
		newButton.choice_id.connect(_chosen_choice)
		_choice_container.add_child(newButton)

##Deletes all created choice buttons in [member _choice_container] 
##and then emits the chosen [param choice_id] with [signal choice_picked]
func _chosen_choice(choice_id : String) -> void:
	_choice_container.hide()
	for c in _choice_container.get_children():
		c.queue_free()
	_currentChoices = []
	
	_check_choices()
	choice_picked.emit(choice_id)
#endregion

##Used for playing a voice line with a given [param audio] [class AudioStream] [br]
##returns a [signal AudioStream.finished] that can be awaited
func play_voice_line(audio : AudioStream) -> Signal:
	_voice_line.stream = audio
	_voice_line.play()
	
	return _voice_line.finished

func _replay_voice_line(audio : AudioStream) -> void:
	_replayed_voice_line.stream = audio
	_replayed_voice_line.play()

##sets [member _voice_line] audio stream to null
func _reset_voice_line_player() -> void:
	_voice_line.stream = null
	_replayed_voice_line.stop()


#region Dialogue box transitions
func fade_out(lengthSeconds : float = 1, _tween : Tween = null) -> Signal:
	_container.modulate.a = 1
	_container.show()
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(_container, "modulate:a", 0, lengthSeconds)
	
	return tween.finished

func fade_in(lengthSeconds : float = 1,  _tween : Tween = null) -> Signal:
	_container.modulate.a = 0
	_container.show()
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(_container, "modulate:a", 1, lengthSeconds) 
	
	return tween.finished
#endregion

#region History/Log functions

func _new_history_box() -> void:
	_history_v_box.add_child(HistoryTextHolder.new_history_text(_name_label.text,_text_area.text,_voice_line.stream))

func _new_choice_history_box(choice : String) -> void:
	_history_v_box.add_child(HistoryChoiceHolder.new_choice_history(choice))

func _open_history_menu() -> void:
	_history.show()
	switch_playback_speed(0)
	

func _close_history_menu() -> void:
	_history.hide()
	switch_playback_speed(speedScale)
	
#endregion
