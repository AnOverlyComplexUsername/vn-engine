extends Control

@export var _text_area: RichTextLabel
@export var _name_label: Label
@export var _text_sfx: AudioStreamPlayer
@export var _speed_button: Button
@export var _auto_button: Button
@export var _hide_button: Button
@export var _dialogue_audio: AudioStreamPlayer
@export var _choice_container: VBoxContainer
@export var _skip_button: Button
@export var _history_button: Button
@export var _history_v_box: VBoxContainer

@export var _history: Control 
@export var _history_close_button: Button 

##speed of dialogue playback
var speedScale : int = 1 

##If dialogue box should return signal upon dialogue completion
var auto_mode : bool = false

var _currentChoices : Array[ChoiceButton]

signal line_finished
signal choice_picked(id : String)
signal skip_scene 

#region Default Functions
func _enter_tree() -> void:
	_speed_button.pressed.connect(next_switch_speed)
	_auto_button.pressed.connect(toggle_auto)
	_hide_button.pressed.connect(hide_dialogue_ui)
	_skip_button.pressed.connect(skip_scene.emit)
	_history_button.pressed.connect(_history.show)
	_history_close_button.pressed.connect(_history.hide)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and self.visible == false:
		self.show()
		switch_playback_speed(speedScale)
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and _text_area.text != "" and self.visible:
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
##toggles auto mode or not; auto mode will automatically go to the next input after dialogue is played back
func toggle_auto() -> void:
	auto_mode = _auto_button.button_pressed

func hide_dialogue_ui() -> void:
	switch_playback_speed(0)
	self.hide()

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
func play_text(letter_delay : float = 0.05) -> void:
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
		play_text(letter_delay)

##Displays and plays dialogue animation 
func begin_dialogue_playback(dialogue : String, char_name : StringName, sfx : AudioStream = null) -> void:
	set_text(dialogue)
	set_name_label(char_name)
	if sfx: _text_sfx.stream = sfx
	else: _text_sfx.stream = null
		
	_text_area.visible_ratio = -1
	
	if not self.visible:
		await fade_in()

	_new_history_box()
	play_text()

##Checks if there are choices at the end of a sentence
func _check_choices() -> void:
	if _currentChoices.is_empty():
		line_finished.emit()
	else: _choice_container.show()
#endregion


#region Choices System
##Set choices that will be displayed at the end of the next sentence 
##choice label will match given choices
func set_choices(...choices : Array) -> void:
	##reset choices for next set of choices
	_currentChoices = []
	
	for choice in choices:
		assert(choice is String) ##validate input
		var newButton : ChoiceButton = ChoiceButton.new(choice)
		_currentChoices.append(newButton)
		newButton.choice_id.connect(_chosen_choice)
		_choice_container.add_child(newButton)

##Set choices that will be displayed at the end of the next sentence 
##Choices will match an "choice_name" : choice_id pattern dictionary
func set_secret_choices(choices : Dictionary[String,String]) -> void:
	##reset choices for next set of choices
	_currentChoices = []
	
	for choice in choices:
		var newButton : ChoiceButton = ChoiceButton.new(choices[choice],choice)
		_currentChoices.append(newButton)
		newButton.choice_id.connect(_chosen_choice)
		_choice_container.add_child(newButton)

func _chosen_choice(choice_id : String) -> void:
	_choice_container.hide()
	for c in _choice_container.get_children():
		c.queue_free()
	_currentChoices = []
	
	choice_picked.emit(choice_id)
#endregion

##plays a given audio; returns a signal upon finished
func play_audio(audio : AudioStream) -> Signal:
	_dialogue_audio.stream = audio
	_dialogue_audio.play()
	
	return _dialogue_audio.finished

#region Dialogue box transitions
func fade_out(lengthSeconds : float = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	self.modulate.a = 1
	self.show()
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 0, lengthSeconds).set_ease(_ease)
	
	return tween.finished

func fade_in(lengthSeconds : float = 1, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	self.modulate.a = 0
	self.show()
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 1, lengthSeconds).set_ease(_ease)
	
	return tween.finished
#endregion

func _new_history_box() -> void:
	_history_v_box.add_child(HistoryTextHolder.new_history_text(_name_label.text,_text_area.text))
	
