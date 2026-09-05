extends PanelContainer

##This class holds an instance of dialogue & voice line and is used for dislpaying
## that data in the history/log panel
class_name HistoryTextHolder


@export var name_label: Label
@export var text_area: RichTextLabel
@export var audio_line_button: Button


const _HISTORY_TEXT_CONTAINER = preload("uid://bly0xkguh7gqf")

var held_audio : AudioStream 

func _ready() -> void:
	audio_line_button.pressed.connect(_play_audio)


func _play_audio() -> void:
	DialogueBox._replay_voice_line(held_audio)

static func new_history_text(_name : String, _text : String, audio : AudioStream = null) -> HistoryTextHolder:
	var new_txt : HistoryTextHolder = _HISTORY_TEXT_CONTAINER.instantiate()
	new_txt.name_label.text = _name
	new_txt.text_area.text = _text
	if audio: new_txt.held_audio = audio
	else: new_txt.audio_line_button.hide()
		
	return new_txt
