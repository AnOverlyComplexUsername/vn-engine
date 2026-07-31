extends Control

@export var text_area: RichTextLabel
@export var name_label: Label
@export var text_sfx: AudioStreamPlayer
@export var speed_button: Button
@export var auto_button: Button
@export var hide_button: Button

##speed of dialogue playback
var speedScale : int = 1 
var auto_mode : bool = false

signal line_finished

func _ready() -> void:
	#self.hide()
	speed_button.pressed.connect(next_switch_speed)
	auto_button.pressed.connect(toggle_auto)
	hide_button.pressed.connect(hide_dialogue_ui)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and self.visible == false:
		self.show()
		switch_playback_speed(speedScale)
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and text_area.text != "" and self.visible:
		if text_area.visible_characters != -1: text_area.visible_characters = -1
		elif text_area.visible_characters == -1: line_finished.emit()
			
func set_name_label(char_name : StringName) -> void:
	name_label.text = char_name

func set_text(line : String) -> void:
	text_area.text = line
	
##toggles auto mode or not; auto mode will automatically go to the next input after dialogue is played back
func toggle_auto() -> void:
	auto_mode = auto_button.button_pressed

func hide_dialogue_ui() -> void:
	switch_playback_speed(0)
	self.hide()

##moves switch speed to next increment
func next_switch_speed() -> void:
	speedScale = wrapi(speedScale + 1,1,4)
	switch_playback_speed(speedScale)
	speed_button.text =  "%sx speed" % speedScale

##Switches playback speed to next setting
func switch_playback_speed(speed : int) -> void:
	Engine.time_scale = speed

##plays text displaying animation 
func play_text(letter_delay : float = 0.05) -> void:
	##Base case; if text fully visible, return
	if text_area.visible_ratio >= 1.0:
		text_area.visible_characters = -1 
		if auto_mode: line_finished.emit()
		return
	else:
		text_area.visible_characters += 1
		if text_sfx: text_sfx.play()
		await get_tree().create_timer(letter_delay,true,true).timeout
		play_text(letter_delay)

##Displays and plays dialogue animation 
func begin_dialogue_playback(dialogue : String, char_name : StringName) -> void:
	set_text(dialogue)
	set_name_label(char_name)
	text_area.visible_ratio = -1
	
	if not self.visible:
		await fade_in()

	
	play_text()


func fade_out(lengthSeconds : float = 1) -> Signal:
	self.modulate.a = 1
	self.show()
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 0, lengthSeconds)
	
	return tween.finished

func fade_in(lengthSeconds : float = 1) -> Signal:
	self.modulate.a = 0
	self.show()
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 1, lengthSeconds)
	
	return tween.finished
