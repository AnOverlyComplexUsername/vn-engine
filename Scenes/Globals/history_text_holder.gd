extends PanelContainer

##Holds text history 
class_name HistoryTextHolder


@export var name_label: Label
@export var text_area: RichTextLabel


const _HISTORY_TEXT_CONTAINER = preload("uid://bly0xkguh7gqf")

static func new_history_text(_name : String, _text : String) -> HistoryTextHolder:
	var new_txt : HistoryTextHolder = _HISTORY_TEXT_CONTAINER.instantiate()
	new_txt.name_label.text = _name
	new_txt.text_area.text = _text
	
	return new_txt
