extends PanelContainer

##Holds text history 
class_name HistoryChoiceHolder


@export var choice_label: Label

const _HISTORY_CHOICE_CONTAINER = preload("uid://bt18661uo6bps")


static func new_choice_history(_choice : String) -> HistoryChoiceHolder:
	var new_txt : HistoryChoiceHolder = _HISTORY_CHOICE_CONTAINER.instantiate()
	new_txt.choice_label.text = "Choice: " + _choice

	return new_txt
