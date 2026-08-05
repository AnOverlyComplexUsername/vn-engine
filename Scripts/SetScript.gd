extends Control

##Class for scripting VN scene & controlling what characters there are 
class_name SetScript

signal set_ended

var _bgm_player : AudioStreamPlayer



func _enter_tree() -> void:
	DialogueBox.skip_scene.connect(end_set)
	
	##bgm player init
	_bgm_player = AudioStreamPlayer.new()

##creates a delay
func wait(durationSeconds : float) -> Signal:
	var clock := get_tree().create_timer(durationSeconds,true,true)
	
	return clock.timeout

##called at the end of a set/scene
func end_set() -> Signal:
	print('skipping')
	return set_ended

##Plays a one-time audio that is freed upon finishing playing and returns when it's finished playing
func play_audio(audio : AudioStream) -> Signal:
	var sfx_player : AudioStreamPlayer = AudioStreamPlayer.new()
	sfx_player.stream = audio
	sfx_player.finished.connect(sfx_player.queue_free)
	add_child(sfx_player)
	sfx_player.play()
	
	return sfx_player.finished

##Updates the BGM player's stream and plays BGM
func play_bgm(audio : AudioStream) -> void:
	_bgm_player.stream = audio
	_bgm_player.play()

##Pauses the BGM
func stop_bgm() -> void:
	_bgm_player.stop()
